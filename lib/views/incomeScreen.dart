import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../utils/APIconfigue.dart';
import 'package:http/http.dart' as http;

// Income Screen with correct naming and property mappings
class IncomeScreen extends StatefulWidget {
  @override
  _IncomeScreenState createState() => _IncomeScreenState();
}

class _IncomeScreenState extends State<IncomeScreen> {
  // List to store raw income data from API
  List<dynamic> _incomes = [];
  bool _isLoading = true;
  String _errorMessage = '';

  @override
  void initState() {
    super.initState();
    // Fetch incomes when screen initializes
    fetchIncomes();
  }

  // Fetch incomes from the API
  Future<void> fetchIncomes() async {
    setState(() {
      _isLoading = true;
      _errorMessage = '';
    });

    try {
      var url = "incomes/getIncomes.php";
      final response = await http.get(Uri.parse(serverPath + url));

      if (response.statusCode == 200) {
        // Print response for debugging
        print("API Response: ${response.body}");

        if (response.body.isNotEmpty) {
          // Parse JSON directly
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

  @override
  Widget build(BuildContext context) {
    // Create formatters for currency and dates
    final formatter = NumberFormat.currency(symbol: '\$');
    final dateFormatter = DateFormat('yyyy-MM-dd'); // Format based on your data

    return RefreshIndicator(
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
            child: Text(
              'Your Incomes',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: _incomes.length,
              itemBuilder: (context, index) {
                // Get the income at this index
                final income = _incomes[index];

                // Format the date if it exists
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

                // Format the amount if it exists
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
                            color: Colors.green, // Changed to green for incomes
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
                    onTap: () {
                      // Show details in a dialog
                      showDialog(
                        context: context,
                        builder: (context) => AlertDialog(
                          title: Text('Income Details'),
                          content: SingleChildScrollView(
                            child: ListBody(
                              children: [
                                Text('Date: $formattedDate'),
                                Text('Amount: $formattedAmount'),
                                if (income['notes'] != null)
                                  Text('Notes: ${income['notes']}'),
                                Text('ID: ${income['incomeID']}'),
                                Text('Category ID: ${income['categoryID']}'),

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