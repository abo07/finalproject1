import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/ExpenseCategory.dart';
import '../utils/APIconfigue.dart';
import 'GoalScreen.dart';
import 'expenseScreen.dart';
import 'newExpenseScreen.dart';
import 'incomeScreen.dart';
import 'package:finalproject1/views/newIncomeScreen.dart';
import 'package:http/http.dart' as http;

// Main HomePage class with BottomNavigationBar
class Homepagescreen extends StatefulWidget {
  const Homepagescreen({super.key, required this.title});
  final String title;

  @override
  State<Homepagescreen> createState() => _HomepagescreenState();
}

class _HomepagescreenState extends State<Homepagescreen> {
  int _selectedIndex = 0; // Default index (Home)

  // Define the titles for each tab
  final List<String> _pageTitles = [
    'Home',
    'Expenses',
    'Income',
    'Goals'
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: Text(
          _pageTitles[_selectedIndex],
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        elevation: 0,
      ),
      body: Stack(
        children: [
          _getScreenForIndex(_selectedIndex), // Display selected screen based on index
        ],
      ),

      // Bottom Navigation Bar
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        type: BottomNavigationBarType.fixed,
        selectedItemColor: Colors.blue,
        unselectedItemColor: Colors.grey,
        onTap: (index) {
          setState(() {
            _selectedIndex = index; // Update selected index
          });
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.money_off),
            label: 'Expenses',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.attach_money),
            label: 'Income',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.flag),
            label: 'Goals',
          ),
        ],
      ),
      // Removed the original FloatingActionButton
    );
  }

  // Helper method to get the correct screen based on index
  Widget _getScreenForIndex(int index) {
    switch (index) {
      case 0:
        return HomePage(); // Home Screen
      case 1:
        return ExpenseScreen(); // Expense Screen
      case 2:
        return IncomeScreen(); // Income Screen
      case 3:
        return GoalScreen(title: 'Goals'); // Goal Screen
      default:
        return HomePage();
    }
  }
}

// Simplified Home Screen
class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  double balance = 0.0;
  List<dynamic> expenseData = [];
  bool isLoading = true;
  double totalExpense = 0.0;

  @override
  void initState() {
    super.initState();
    loadData();
  }

  Future<void> loadData() async {
    setState(() {
      isLoading = true;
    });

    await Future.wait([
      fetchBalance(),
      fetchExpenseData()
    ]);

    setState(() {
      isLoading = false;
    });
  }

  Future<void> fetchBalance() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      var userID = prefs.getInt("userID");
      var url = "ExpenseCategory/getCurrentBalance.php?userID=$userID";
      final response = await http.get(Uri.parse(serverPath + url));

      if (response.statusCode == 200) {
        var data = json.decode(response.body);
        setState(() {
          balance = double.tryParse(data["balance"].toString()) ?? 0.0;
        });
      }
    } catch (e) {
      print('Error fetching balance: $e');
    }
  }

  Future<void> fetchExpenseData() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      var userID = prefs.getInt("userID");
      var url = "ExpenseCategory/getReports.php?userID=$userID";
      final response = await http.get(Uri.parse(serverPath + url));

      if (response.statusCode == 200) {
        var data = json.decode(response.body);
        setState(() {
          expenseData = data;
          // Calculate total expense
          totalExpense = 0.0;
          for (var item in expenseData) {
            totalExpense += double.tryParse(item['amount'].toString()) ?? 0.0;
          }
        });
      }
    } catch (e) {
      print('Error fetching expense data: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return isLoading
        ? Center(child: CircularProgressIndicator())
        : RefreshIndicator(
      onRefresh: loadData,
      child: SingleChildScrollView(
        physics: AlwaysScrollableScrollPhysics(),
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Balance Card
            Card(
              elevation: 2,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: Padding(
                padding: EdgeInsets.all(20),
                child: Column(
                  children: [
                    Text(
                      'Current Balance',
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.grey[700],
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      '\$${balance.toStringAsFixed(2)}',
                      style: TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                        color: balance >= 0 ? Colors.green : Colors.red,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            SizedBox(height: 24),

            // Quick Actions
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildActionButton(
                  context,
                  Icons.money_off,
                  'Expense',
                  Colors.red[100]!,
                  Colors.red,
                      () => Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => newExpenseScreen(title: 'Add Expense'))
                  ),
                ),
                _buildActionButton(
                  context,
                  Icons.attach_money,
                  'Income',
                  Colors.green[100]!,
                  Colors.green,
                      () => Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => newIncomeScreen(title: 'Add Income'))
                  ),
                ),
              ],
            ),

            SizedBox(height: 24),

            // Chart Section
            expenseData.isEmpty
                ? Center(
              child: Padding(
                padding: EdgeInsets.all(30),
                child: Column(
                  children: [
                    Icon(Icons.bar_chart, size: 70, color: Colors.grey[400]),
                    SizedBox(height: 16),
                    Text(
                      'No expense data available',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ),
              ),
            )
                : Card(
              elevation: 2,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: Padding(
                padding: EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Expense Breakdown',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 16),
                    Container(
                      height: 200,
                      child: PieChart(
                        PieChartData(
                          sections: expenseData.map((item) {
                            final value = double.tryParse(item['amount'].toString()) ?? 0.0;
                            final title = item['category'];
                            final colorStr = item['color'];
                            final color = HexColor(colorStr);

                            return PieChartSectionData(
                              value: value,
                              color: color,
                              title: '',
                              radius: 50,
                            );
                          }).toList(),
                          sectionsSpace: 2,
                          centerSpaceRadius: 30,
                        ),
                      ),
                    ),
                    SizedBox(height: 16),
                    // Legend with percentages
                    Column(
                      children: expenseData.map((item) {
                        final amount = double.tryParse(item['amount'].toString()) ?? 0.0;
                        // Calculate percentage
                        final percentage = totalExpense > 0
                            ? (amount / totalExpense * 100)
                            : 0.0;

                        return Padding(
                          padding: EdgeInsets.symmetric(vertical: 4),
                          child: Row(
                            children: [
                              Container(
                                width: 12,
                                height: 12,
                                decoration: BoxDecoration(
                                  color: HexColor(item['color']),
                                  shape: BoxShape.circle,
                                ),
                              ),
                              SizedBox(width: 8),
                              Expanded(
                                child: Text(
                                  item['category'],
                                  style: TextStyle(fontSize: 14),
                                ),
                              ),
                              Text(
                                '\$${amount.toStringAsFixed(2)} (${percentage.toStringAsFixed(1)}%)',
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        );
                      }).toList(),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActionButton(
      BuildContext context,
      IconData icon,
      String label,
      Color bgColor,
      Color iconColor,
      VoidCallback onPressed
      ) {
    return InkWell(
      onTap: onPressed,
      child: Container(
        width: 140,
        padding: EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 32, color: iconColor),
            SizedBox(height: 8),
            Text(
              label,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: iconColor,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class HexColor extends Color {
  static int _getColorFromHex(String hexColor) {
    hexColor = hexColor.toUpperCase().replaceAll("#", "");
    if (hexColor.length == 6) {
      hexColor = "FF" + hexColor;
    }
    return int.parse(hexColor, radix: 16);
  }

  HexColor(final String hexColor) : super(_getColorFromHex(hexColor));
}