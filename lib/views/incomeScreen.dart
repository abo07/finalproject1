import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../utils/APIconfigue.dart';
import 'package:http/http.dart' as http;

import 'newIncomeScreen.dart';


class IncomeScreen extends StatefulWidget {
  @override
  _IncomeScreenState createState() => _IncomeScreenState();
}

class _IncomeScreenState extends State<IncomeScreen> {

  List<dynamic> _incomes = [];
  bool _isLoading = true;
  String _errorMessage = '';
  String _selectedTimeFrame = 'All Time'; // Default time frame

  @override
  void initState() {
    super.initState();

    fetchIncomes();
  }

  Future<void> fetchIncomes() async {
    setState(() {
      _isLoading = true;
      _errorMessage = '';
    });

    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      var userID = prefs.getInt("userID");

      var url = "incomes/getIncomes.php?userID=" + userID.toString();
      final response = await http.get(Uri.parse(serverPath + url));

      if (response.statusCode == 200) {

        print("API Response: ${response.body}");

        if (response.body.isNotEmpty) {

          final jsonData = json.decode(response.body);
          setState(() {
            _incomes = jsonData;
            _isLoading = false;
          });
        } else {
          setState(() {
            _incomes = [];
            _isLoading = false;
          });
        }
      } else {
        setState(() {
          _errorMessage = 'Failed to load incomes. Status: ${response.statusCode}';
          _isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        _errorMessage = 'Error: $e';
        _isLoading = false;
      });
      print("Exception while fetching incomes: $e");
    }
  }

  Future deleteExpense(BuildContext context, String incomeID) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? getInfoDeviceSTR = prefs.getString("getInfoDeviceSTR");
    var url = "incomes/deleteIncome.php?incomeID=" + incomeID;
    final response = await http.get(Uri.parse(serverPath + url));
    print(serverPath + url);
    print(serverPath + url);
    print(serverPath + url);

    fetchIncomes();
  }

  @override
  Widget build(BuildContext context) {
    // Create formatters for currency and dates
    final formatter = NumberFormat.currency(symbol: '\$');
    final dateFormatter = DateFormat('yyyy-MM-dd'); // Format based on your data

    return Scaffold(
      body: RefreshIndicator(
        onRefresh: fetchIncomes,
        child: _isLoading
            ? Center(child: CircularProgressIndicator(color: Colors.green))
            : _errorMessage.isNotEmpty
            ? Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Error loading incomes',
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 16),
              Text(_errorMessage),
              SizedBox(height: 16),
              ElevatedButton(
                onPressed: fetchIncomes,
                child: Text('Retry'),
              ),
            ],
          ),
        )
            : _incomes.isEmpty
            ? Center(
          child: Text(
            'No incomes available',
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
                    'Your Incomes',
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
                      icon: Icon(Icons.filter_list, color: Colors.green, size: 20),
                      underline: SizedBox(), // Remove the default underline
                      isDense: true,
                      style: TextStyle(color: Colors.black, fontSize: 14),
                      onChanged: (String? newValue) {
                        setState(() {
                          _selectedTimeFrame = newValue!;

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
                itemCount: _incomes.length,
                itemBuilder: (context, index) {
                  // Get the income at this index
                  final income = _incomes[index];


                  String formattedDate = 'No date';
                  try {
                    if (income['incomeDate'] != null) {
                      final date = dateFormatter.parse(income['incomeDate']);
                      formattedDate = DateFormat('MMM d, yyyy').format(date);
                    }
                  } catch (e) {
                    formattedDate = income['incomeDate'] ?? 'Unknown date';
                    print("Date parsing error: $e");
                  }


                  String formattedAmount = 'N/A';
                  try {
                    if (income['amount'] != null) {
                      final amount = double.tryParse(income['amount'].toString()) ?? 0.0;
                      formattedAmount = formatter.format(amount);
                    }
                  } catch (e) {
                    formattedAmount = income['amount']?.toString() ?? 'N/A';
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
                              color: Colors.green,
                            ),
                          ),
                        ],
                      ),
                      subtitle: income['notes'] != null && income['notes'].toString().isNotEmpty
                          ? Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(height: 8),
                          Text(
                            income['notes'],
                            style: TextStyle(
                              color: Colors.grey.shade700,
                            ),
                          ),
                        ],
                      )
                          : null,
                      trailing: IconButton(
                        icon: Icon(Icons.delete, color: Colors.red),
                        onPressed: () => deleteExpense(context, income['incomeID'].toString()),
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
                                  if (income['notes'] != null)
                                    Text('Notes: ${income['notes']}'),
                                  Text('Category: ${income['categoryName']}'),
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
        backgroundColor: Colors.green,
        onPressed: () {
          print("fghjkl");
          Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => newIncomeScreen(title: 'Add Income'))
          );
        },
        child: Icon(
          Icons.add,
          color: Colors.white,
        ),
      ),
    );
  }
}