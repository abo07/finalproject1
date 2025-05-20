import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/Expense.dart';
import '../utils/APIconfigue.dart';
import 'newExpenseScreen.dart';
import 'package:http/http.dart' as http;

class ExpenseScreen extends StatefulWidget {
  @override
  _ExpenseScreenState createState() => _ExpenseScreenState();
}

class _ExpenseScreenState extends State<ExpenseScreen> {
  List<dynamic> _expenses = [];
  bool _isLoading = true;
  String _errorMessage = '';
  String _selectedTimeFrame = 'All Time'; // Default time frame

  @override
  void initState() {
    super.initState();
    fetchExpenses();
  }

  Future<void> fetchExpenses() async {
    setState(() {
      _isLoading = true;
      _errorMessage = '';
    });

    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      var userID = prefs.getInt("userID");

      var url = "expenses/getExpenses.php?userID=" + userID.toString();
      final response = await http.get(Uri.parse(serverPath + url));

      if (response.statusCode == 200) {
        print("API Response: ${response.body}");

        if (response.body.isNotEmpty) {
          final jsonData = json.decode(response.body);
          setState(() {
            _expenses = jsonData;
            _isLoading = false;
          });
        } else {
          setState(() {
            _expenses = [];
            _isLoading = false;
          });
        }
      } else {
        setState(() {
          _errorMessage = 'Failed to load expenses. Status: ${response.statusCode}';
          _isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        _errorMessage = 'Error: $e';
        _isLoading = false;
      });
      print("Exception while fetching expenses: $e");
    }
  }


  Future deleteExpense(BuildContext context, String expenseID) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? getInfoDeviceSTR = prefs.getString("getInfoDeviceSTR");
    var url = "expenses/deleteExpense.php?expenseID=" + expenseID;
    final response = await http.get(Uri.parse(serverPath + url));
    print(serverPath + url);
    print(serverPath + url);
    print(serverPath + url);

    fetchExpenses();
  }

  @override
  Widget build(BuildContext context) {
    final formatter = NumberFormat.currency(symbol: '\$');
    final dateFormatter = DateFormat('yyyy-MM-dd');

    return Scaffold(
      body: RefreshIndicator(
        onRefresh: fetchExpenses,
        child: _isLoading
            ? Center(child: CircularProgressIndicator(color: Colors.red))
            : _errorMessage.isNotEmpty
            ? Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Error loading expenses',
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 16),
              Text(_errorMessage),
              SizedBox(height: 16),
              ElevatedButton(
                onPressed: fetchExpenses,
                child: Text('Retry'),
              ),
            ],
          ),
        )
            : _expenses.isEmpty
            ? Center(
          child: Text(
            'No expenses available',
            style: TextStyle(fontSize: 23, color: Colors.black),
          ),
        )
            : Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Your Expenses',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  // Time frame filter dropdown
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey.shade300),
                      borderRadius: BorderRadius.circular(5),
                    ),
                    child: DropdownButton<String>(
                      value: _selectedTimeFrame,
                      icon: Icon(Icons.filter_list, color: Colors.red, size: 20),
                      underline: SizedBox(), // Remove the default underline
                      isDense: true,
                      style: TextStyle(color: Colors.black, fontSize: 14),
                      onChanged: (String? newValue) {
                        setState(() {
                          _selectedTimeFrame = newValue!;
                          // In a real app, filter logic would go here
                        });
                      },
                      items: <String>['All Time', 'Last Month', 'Last 3 Months', 'Last 6 Months', 'Last Year']
                          .map<DropdownMenuItem<String>>((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: _expenses.length,
                itemBuilder: (context, index) {
                  final expense = _expenses[index];

                  String formattedDate = 'No date';
                  try {
                    if (expense['expenseDate'] != null) {
                      final date = dateFormatter.parse(expense['expenseDate']);
                      formattedDate = DateFormat('MMM d, yyyy').format(date);
                    }
                  } catch (e) {
                    formattedDate = expense['expenseDate'] ?? 'Unknown date';
                  }

                  String formattedAmount = 'N/A';
                  try {
                    if (expense['amount'] != null) {
                      final amount = double.tryParse(expense['amount'].toString()) ?? 0.0;
                      formattedAmount = formatter.format(amount);
                    }
                  } catch (e) {
                    formattedAmount = expense['amount']?.toString() ?? 'N/A';
                  }

                  return Card(
                    margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    elevation: 2,
                    child: ListTile(
                      contentPadding: EdgeInsets.all(16),
                      title: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          // Date
                          Expanded(
                            child: Text(
                              formattedDate,
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                              ),
                            ),
                          ),
                          // Amount
                          Text(
                            formattedAmount,
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.red,
                            ),
                          ),
                        ],
                      ),
                      subtitle: expense['notes'] != null && expense['notes'].toString().isNotEmpty
                          ? Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(height: 8),
                          Text(
                            expense['notes'],
                            style: TextStyle(
                              color: Colors.grey.shade700,
                            ),
                          ),
                        ],
                      )
                          : null,
                      // Fixed delete button
                      trailing: IconButton(
                        icon: Icon(Icons.delete, color: Colors.red),
                        onPressed: () => deleteExpense(context, expense['expenseID'].toString()),
                      ),

                      onTap: () {

                        showDialog(
                          context: context,
                          builder: (context) => AlertDialog(
                            title: Text('Expense Details'),
                            content: SingleChildScrollView(
                              child: ListBody(
                                children: [
                                  Text('Date: $formattedDate'),
                                  Text('Amount: $formattedAmount'),
                                  if (expense['notes'] != null)
                                    Text('Notes: ${expense['notes']}'),
                                  Text('Category: Transportation'),
                                ],
                              ),
                            ),
                            actions: [
                              TextButton(
                                onPressed: () => Navigator.of(context).pop(),
                                child: Text('Close'),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),

      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.red,
        onPressed: () {
          Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => newExpenseScreen(title: 'Add Expense'))
          );
        },
        child: Icon(
          Icons.remove,
          color: Colors.white,
        ),
      ),
    );
  }
}