import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import '../utils/APIconfigue.dart';
import 'editProfile.dart';
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
  var total = 2425; // Just an example balance

  // Define the titles for each tab
  final List<String> _pageTitles = [
    'Home Page',
    'Expenses',
    'Income',
    'Edit Profile'
  ];



  Future getReports() async {

    var url = "users/getReports.php";
    final response = await http.get(Uri.parse(serverPath + url));
    // print(serverPath + url);
    List<WorkLogModel> arr = [];

    for(Map<String, dynamic> i in json.decode(response.body)){
      arr.add(WorkLogModel.fromJson(i));
    }

    return arr;
  }




  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(_pageTitles[_selectedIndex]), // Dynamic title based on selected index
      ),
      body: Stack(
        children: [
          _getScreenForIndex(_selectedIndex), // Display selected screen based on index

          // Only show FABs when on the HomePage (index 0)
          if (_selectedIndex == 0) ...[
            // Floating action button - bottom left (Expense)
            Positioned(
              left: 20,
              bottom: 20,
              child: FloatingActionButton(
                heroTag: "btnExpense", // Unique tag to prevent hero animation conflicts
                onPressed: () {
                   Navigator.push(context, MaterialPageRoute(
                     builder: (context) => newExpenseScreen(title: 'Add Expense'),
                   ));
                },
                child: Icon(Icons.money_off),
                backgroundColor: Colors.redAccent,
              ),
            ),

            // Floating action button - bottom right (Income)
            Positioned(
              right: 20,
              bottom: 20,
              child: FloatingActionButton(
                heroTag: "btnIncome", // Unique tag to prevent hero animation conflicts
                onPressed: () {
                  Navigator.push(context, MaterialPageRoute(
                    builder: (context) => newIncomeScreen(title: 'Add Income'),
                  ));
                },
                child: Icon(Icons.attach_money),
                backgroundColor: Colors.green,
              ),
            ),
          ],
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        type: BottomNavigationBarType.fixed,
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
            label: 'Incomes',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
      ),
      // Main floating action button removed as requested
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
        return IncomeScreen(); // Income Screen - Fixed casing from incomeScreen to IncomeScreen
      case 3:
        return editProfile(title: 'Edit Profile'); // Profile Screen
      default:
        return HomePage();
    }
  }
}

// Home Screen (Main screen with balance and buttons)
class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  var total = 333; // Example balance
  int touchedIndex = -1;

  // Sample expense data
  final List<ExpenseCategory> categories = [
    ExpenseCategory('Food', 450, Colors.red),
    ExpenseCategory('Transport', 350, Colors.blue),
    ExpenseCategory('Entertainment', 280, Colors.green),
    ExpenseCategory('Shopping', 520, Colors.amber),
    ExpenseCategory('Bills', 600, Colors.purple),
    ExpenseCategory('Others', 225, Colors.orange),
  ];

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Center(
        child: Container(
          alignment: Alignment.center,
          constraints: BoxConstraints(maxWidth: 800),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                SizedBox(height: 20),
                Text(
                  'Current Balance',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
                Text(
                  '\$${total}',
                  style: TextStyle(fontSize: 36, fontWeight: FontWeight.w600, color: Colors.green),
                ),
                SizedBox(height: 30),
                Container(
                  width: double.infinity,
                  padding: EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade100,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    children: [
                      Text(
                        'Expense Categories',
                        style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(height: 16),
                      // Pie Chart Container with fixed height
                      Container(
                        height: 280,
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            // Pie Chart
                            Expanded(
                              flex: 2,
                              child: PieChart(
                                PieChartData(
                                  pieTouchData: PieTouchData(
                                    touchCallback: (FlTouchEvent event, pieTouchResponse) {
                                      setState(() {
                                        if (!event.isInterestedForInteractions ||
                                            pieTouchResponse == null ||
                                            pieTouchResponse.touchedSection == null) {
                                          touchedIndex = -1;
                                          return;
                                        }
                                        touchedIndex = pieTouchResponse.touchedSection!.touchedSectionIndex;
                                      });
                                    },
                                  ),
                                  borderData: FlBorderData(show: false),
                                  sectionsSpace: 2,
                                  centerSpaceRadius: 40,
                                  sections: generatePieChartSections(),
                                ),
                              ),
                            ),
                            // Legend with scrollable container
                            Expanded(
                              flex: 1,
                              child: Container(
                                padding: EdgeInsets.symmetric(horizontal: 8),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: generateLegendItems(),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

                SizedBox(height: 70), // Extra space at bottom to avoid FAB overlap
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Generate pie chart sections
  List<PieChartSectionData> generatePieChartSections() {
    return List.generate(categories.length, (i) {
      final isTouched = i == touchedIndex;
      final double fontSize = isTouched ? 18 : 14;
      final double radius = isTouched ? 110 : 100;
      final percentage = (categories[i].amount / total * 100).toStringAsFixed(1);

      return PieChartSectionData(
        color: categories[i].color,
        value: categories[i].amount,
        title: '$percentage%',
        radius: radius,
        titleStyle: TextStyle(
          fontSize: fontSize,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      );
    });
  }

  // Generate legend items
  List<Widget> generateLegendItems() {
    return categories.map((category) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 4),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 14,
              height: 14,
              color: category.color,
            ),
            SizedBox(width: 8),
            Expanded(
              child: Text(
                '${category.name}: \$${category.amount.toStringAsFixed(0)}',
                style: TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      );
    }).toList();
  }
}

