import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import '../utils/APIconfigue.dart';
import '../utils/utils.dart';
import 'package:intl/intl.dart';

const List<String> categories = <String>['job salary', 'side job', 'gifts', 'buisness'];
// Map category names to IDs
const Map<String, int> categoryIds = {
  'job salary': 1,
  'side job': 2,
  'gifts': 3,
  'buisness': 4
};

class newIncomeScreen extends StatefulWidget {
  const newIncomeScreen({super.key, required this.title});

  final String title;

  @override
  State<newIncomeScreen> createState() => _newIncomeScreenState();
}

class _newIncomeScreenState extends State<newIncomeScreen> {
  DateTime? _selectedDate = DateTime.now(); // Default to today
  TextEditingController amountController = TextEditingController();
  TextEditingController categoryController = TextEditingController();
  TextEditingController notesController = TextEditingController();
  bool _isLoading = false;

  // Function to display the date picker
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
              primary: Colors.green,
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

  Future<void> insertIncome() async {
    // Format date for database (YYYY-MM-DD)
    String formattedDate = "${_selectedDate!.year}-${_selectedDate!.month.toString().padLeft(2, '0')}-${_selectedDate!.day.toString().padLeft(2, '0')}";

    // Get categoryID from the selected category name
    int categoryID = categoryIds[categoryController.text] ?? 0;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var userID = prefs.getInt("userID");

    // URL encode the notes to handle special characters
    String encodedNotes = Uri.encodeComponent(notesController.text);

    // Build the URL with all the data
    var url = serverPath + "incomes/insertIncome.php?amount=" + amountController.text +
        "&categoryID=" + categoryID.toString() +
        "&notes=" + encodedNotes +
        "&date=" + formattedDate +
        "&userID=" + userID.toString();

    // Send the request to the server
    final response = await http.get(Uri.parse(url));

    // Go back to previous screen
    Navigator.pop(context);
  }

  Future<void> _saveIncome() async {
    // Check if required fields are filled
    if (_selectedDate == null || amountController.text.isEmpty || categoryController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Please fill all required fields'),
          backgroundColor: Colors.green,
        ),
      );
      return;
    }

    // Show loading spinner
    setState(() {
      _isLoading = true;
    });

    // Call the function to send data to PHP
    await insertIncome();

    // Hide loading spinner
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
        backgroundColor: Colors.green,
        title: Text(
          "Add Income",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        elevation: 0,
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator(color: Colors.green))
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
                    // Amount Field
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
                          borderSide: BorderSide(color: Colors.green),
                        ),
                        prefixIcon: Icon(Icons.attach_money, color: Colors.green),
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

                    // Category Selection
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
                          prefixIcon: Icon(Icons.category, color: Colors.green),
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

                    // Date Selection
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
                            Icon(Icons.calendar_today, color: Colors.green, size: 20),
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

                    // Notes Field
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
                          borderSide: BorderSide(color: Colors.green),
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

            // Save Button
            SizedBox(
              width: double.infinity,
              height: 48,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  elevation: 0,
                ),
                onPressed: _saveIncome,
                child: Text(
                  'Save Income',
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