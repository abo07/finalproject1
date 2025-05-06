import 'package:finalproject1/models/Expense.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import '../utils/APIconfigue.dart';
import '../utils/utils.dart';

const List<String> categories = <String>['Housing', 'Transportation', 'Food', 'Health & Insurance', 'Debt & Loans', 'Savings & Investments', 'Gifts & Donations'];
// Map category names to IDs (assuming your database uses numeric IDs)
const Map<String, int> categoryIds = {
  'Housing': 1,
  'Transportation': 2,
  'Food': 3,
  'Health & Insurance': 4,
  'Debt & Loans': 5,
  'Savings & Investments': 6,
  'Gifts & Donations': 7
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

  // Function to display the date picker
  Future<void> _pickDate(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );

    if (pickedDate != null && pickedDate != _selectedDate) {
      setState(() {
        _selectedDate = pickedDate;
      });
    }
  }



  Future<void> insertExpense() async {
  // Format date for database (YYYY-MM-DD)
  String formattedDate = "${_selectedDate!.year}-${_selectedDate!.month.toString().padLeft(2, '0')}-${_selectedDate!.day.toString().padLeft(2, '0')}";
  // Get categoryID from the selected category name
  int categoryID = categoryIds[categoryController.text] ?? 0;

  SharedPreferences prefs = await SharedPreferences.getInstance();
  var userID = prefs.getInt("userID");


  // Build the URL with all the data
  var url = serverPath + "expenses/insertExpense.php?amount=" + amountController.text +
  "&categoryID=" + categoryID.toString() +
  "&notes=" + notesController.text +
  "&date=" + formattedDate + "&userID=" + userID.toString() ;

  // Send the request to the server
  final response = await http.get(Uri.parse(url));
  print("Connecting to: " + url);

  // Go back to previous screen
  Navigator.pop(context);
  }



  Future<void> _saveExpense() async {
    // Check if required fields are filled
    if (_selectedDate == null || amountController.text.isEmpty || categoryController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill all required fields')),
      );
      return;
    }

    // Show loading spinner
    setState(() {
      _isLoading = true;
    });

    // Call the function to send data to PHP
    await insertExpense();

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
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text("New Expense"),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            const Text("Expense date:", style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Row(
              children: [
                Text(
                  _selectedDate == null
                      ? 'No date selected'
                      : '${_selectedDate!.year}-${_selectedDate!.month.toString().padLeft(2, '0')}-${_selectedDate!.day.toString().padLeft(2, '0')}',
                  style: const TextStyle(fontSize: 16),
                ),
                const SizedBox(width: 16),
                ElevatedButton(
                  onPressed: () => _pickDate(context),
                  child: const Text('Change Date'),
                ),
              ],
            ),
            const SizedBox(height: 24),

            const Text("Choose category:", style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            DropdownMenu<String>(
              width: MediaQuery.of(context).size.width - 32, // Full width minus padding
              initialSelection: categories.first,
              controller: categoryController,
              onSelected: (String? value) {
                if (value != null) {
                  categoryController.text = value;
                }
              },
              dropdownMenuEntries: categories.map((String value) {
                return DropdownMenuEntry<String>(value: value, label: value);
              }).toList(),
            ),
            const SizedBox(height: 24),

            const Text("Amount:", style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            TextField(
              controller: amountController,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                hintText: 'Enter amount',
                prefixText: '\$',
              ),
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
              inputFormatters: <TextInputFormatter>[
                // Allow decimal numbers for currency
                FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,2}')),
              ],
            ),
            const SizedBox(height: 24),

            const Text("Notes:", style: TextStyle(fontWeight: FontWeight.bold)),

            const SizedBox(height: 8),

            TextField(
              controller: notesController,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                hintText: 'Enter notes (optional)',
              ),
              maxLines: 3, // Allow multiple lines for notes
              keyboardType: TextInputType.text, // Changed from number to text
            ),

            const SizedBox(height: 32),

            Center(
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 12),
                ),
                onPressed: _saveExpense,
                child: const Text('Add Expense', style: TextStyle(fontSize: 16)),
              ),
            ),

          ],
        ),
      ),
    );
  }
}