import 'package:finalproject1/models/Expense.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import '../utils/APIconfigue.dart';
import '../utils/utils.dart';
import 'package:intl/intl.dart';

const List<String> categories = <String>['Housing', 'Transportation', 'Food', 'Health & Insurance', 'Debt & Loans', 'Savings & Investments', 'Gifts & Donations','Goals'];

const Map<String, int> categoryIds = {
  'Housing': 1,
  'Transportation': 2,
  'Food': 3,
  'Health & Insurance': 4,
  'Debt & Loans': 5,
  'Savings & Investments': 6,
  'Gifts & Donations': 7,
  'Goals': 8
};

class newExpenseScreen extends StatefulWidget {
  const newExpenseScreen({super.key, required this.title});

  final String title;

  @override
  State<newExpenseScreen> createState() => _newExpenseScreenState();
}

class _newExpenseScreenState extends State<newExpenseScreen> {
  DateTime? _selectedDate = DateTime.now(); // Default to today
  TextEditingController amountController = TextEditingController();
  TextEditingController categoryController = TextEditingController();
  TextEditingController notesController = TextEditingController();
  bool _isLoading = false; // Add a loading state


  Future<void> _pickDate(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: Colors.red,
              onPrimary: Colors.white,
              onSurface: Colors.black,
            ),
          ),
          child: child!,
        );
      },
    );

    if (pickedDate != null && pickedDate != _selectedDate) {
      setState(() {
        _selectedDate = pickedDate;
      });
    }
  }

  Future<void> insertExpense() async {

    String formattedDate = "${_selectedDate!.year}-${_selectedDate!.month.toString().padLeft(2, '0')}-${_selectedDate!.day.toString().padLeft(2, '0')}";

    int categoryID = categoryIds[categoryController.text] ?? 0;

    SharedPreferences prefs = await SharedPreferences.getInstance();
    var userID = prefs.getInt("userID");


    var url = serverPath + "expenses/insertExpense.php?amount=" + amountController.text +
        "&categoryID=" + categoryID.toString() +
        "&notes=" + notesController.text +
        "&date=" + formattedDate + "&userID=" + userID.toString();


    final response = await http.get(Uri.parse(url));
    print("Connecting to: " + url);


    Navigator.pop(context);
  }

  Future<void> _saveExpense() async {

    if (_selectedDate == null || amountController.text.isEmpty || categoryController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Please fill all required fields'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }


    setState(() {
      _isLoading = true;
    });


    await insertExpense();


    setState(() {
      _isLoading = false;
    });
  }

  @override
  void initState() {
    super.initState();
    categoryController.text = categories.first; // Set default category
  }

  @override
  void dispose() {
    amountController.dispose();
    categoryController.dispose();
    notesController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final dateFormatter = DateFormat('MMM d, yyyy');

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.red,
        title: Text(
          "Add Expense",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        elevation: 0,
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator(color: Colors.red))
          : SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            // Main Card
            Card(
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
                      "Amount",
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: Colors.grey[700],
                      ),
                    ),
                    SizedBox(height: 8),
                    TextField(
                      controller: amountController,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: BorderSide(color: Colors.grey.shade300),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: BorderSide(color: Colors.grey.shade300),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: BorderSide(color: Colors.red),
                        ),
                        prefixIcon: Icon(Icons.attach_money, color: Colors.red),
                        hintText: '0.00',
                        contentPadding: EdgeInsets.symmetric(vertical: 12, horizontal: 12),
                      ),
                      style: TextStyle(fontSize: 18, color: Colors.black),
                      textAlign: TextAlign.left,
                      keyboardType: TextInputType.numberWithOptions(decimal: true),
                      inputFormatters: <TextInputFormatter>[
                        FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,2}')),
                      ],
                    ),

                    SizedBox(height: 16),

                    Divider(),

                    SizedBox(height: 16),


                    Text(
                      "Category",
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: Colors.grey[700],
                      ),
                    ),
                    SizedBox(height: 8),
                    Container(
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey.shade300),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: DropdownButtonFormField<String>(
                        value: categoryController.text,
                        decoration: InputDecoration(
                          prefixIcon: Icon(Icons.category, color: Colors.red),
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                        ),
                        icon: Icon(Icons.arrow_drop_down, color: Colors.grey),
                        style: TextStyle(color: Colors.black, fontSize: 16),
                        isExpanded: true,
                        onChanged: (String? value) {
                          if (value != null) {
                            categoryController.text = value;
                          }
                        },
                        items: categories.map<DropdownMenuItem<String>>((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value),
                          );
                        }).toList(),
                      ),
                    ),

                    SizedBox(height: 16),

                    Divider(),

                    SizedBox(height: 16),


                    Text(
                      "Date",
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: Colors.grey[700],
                      ),
                    ),
                    SizedBox(height: 8),
                    InkWell(
                      onTap: () => _pickDate(context),
                      child: Container(
                        width: double.infinity,
                        padding: EdgeInsets.symmetric(vertical: 12, horizontal: 12),
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey.shade300),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Row(
                          children: [
                            Icon(Icons.calendar_today, color: Colors.red, size: 20),
                            SizedBox(width: 12),
                            Text(
                              _selectedDate == null ? 'Select date' : dateFormatter.format(_selectedDate!),
                              style: TextStyle(fontSize: 16, color: Colors.black),
                            ),
                            Spacer(),
                            Icon(Icons.arrow_drop_down, color: Colors.grey),
                          ],
                        ),
                      ),
                    ),

                    SizedBox(height: 16),

                    Divider(),

                    SizedBox(height: 16),


                    Text(
                      "Notes (Optional)",
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: Colors.grey[700],
                      ),
                    ),
                    SizedBox(height: 8),
                    TextField(
                      controller: notesController,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: BorderSide(color: Colors.grey.shade300),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: BorderSide(color: Colors.grey.shade300),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: BorderSide(color: Colors.red),
                        ),
                        hintText: 'Add notes...',
                        contentPadding: EdgeInsets.all(12),
                      ),
                      style: TextStyle(fontSize: 16),
                      maxLines: 3,
                    ),
                  ],
                ),
              ),
            ),

            SizedBox(height: 24),


            SizedBox(
              width: double.infinity,
              height: 48,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  elevation: 0,
                ),
                onPressed: _saveExpense,
                child: Text(
                  'Save Expense',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}