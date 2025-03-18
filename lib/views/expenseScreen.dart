import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/Expense.dart';
import '../utils/APIconfigue.dart';
import 'newExpenseScreen.dart';
import 'package:http/http.dart' as http;

// Expense Screen with correct property mappings
class ExpenseScreen extends StatefulWidget {
  @override
  _ExpenseScreenState createState() => _ExpenseScreenState();
}

class _ExpenseScreenState extends State<ExpenseScreen> {
  // List to store raw expense data from API
  List<dynamic> _expenses = [];
  bool _isLoading = true;
  String _errorMessage = '';

  @override
  void initState() {
    super.initState();
    // Fetch expenses when screen initializes
    fetchExpenses();
  }

  // Fetch expenses directly as JSON to avoid model mapping issues
  Future<void> fetchExpenses() async {
    setState(() {
      _isLoading = true;
      _errorMessage = '';
    });

    try {
      var url = "expenses/getExpenses.php";
      final response = await http.get(Uri.parse(serverPath + url));

      if (response.statusCode == 200) {
        // Print response for debugging
        print("API Response: ${response.body}");

        if (response.body.isNotEmpty) {
          // Parse JSON directly
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

  @override
  Widget build(BuildContext context) {
    // Create formatters for currency and dates
    final formatter = NumberFormat.currency(symbol: '\$');
    final dateFormatter = DateFormat('yyyy-MM-dd'); // Format based on your data

    return RefreshIndicator(
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
            child: Text(
              'Your Expenses',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: _expenses.length,
              itemBuilder: (context, index) {
                // Get the expense at this index
                final expense = _expenses[index];

                // Format the date if it exists
                String formattedDate = 'No date';
                try {
                  if (expense['expenseDate'] != null) {
                    final date = dateFormatter.parse(expense['expenseDate']);
                    formattedDate = DateFormat('MMM d, yyyy').format(date);
                  }
                } catch (e) {
                  formattedDate = expense['expenseDate'] ?? 'Unknown date';
                  print("Date parsing error: $e");
                }

                // Format the amount if it exists
                String formattedAmount = 'N/A';
                try {
                  if (expense['amount'] != null) {
                    final amount = double.tryParse(expense['amount'].toString()) ?? 0.0;
                    formattedAmount = formatter.format(amount);
                  }
                } catch (e) {
                  formattedAmount = expense['amount']?.toString() ?? 'N/A';
                  print("Amount parsing error: $e");
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
                    onTap: () {
                      // Show details in a dialog
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
                                Text('ID: ${expense['expenseID']}'),
                                Text('Category ID: ${expense['catogeryID']}'),
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
    );
  }
}