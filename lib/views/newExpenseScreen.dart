import 'package:finalproject1/models/Expense.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
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
  const newExpenseScreen({super.key, required this.title, required this.userId});

  final String title;
  final int userId; // Add user ID as a parameter

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


  $amount = insertedStr($_GET['amount']);
  $category = insertedStr($_GET['category']);
  $notes = insertedStr($_GET['notes']);
  $date = insertedStr($_GET['date']);
  $userID = insertedStr($_GET['userID']);



  Future insertExpense(Expense expense) async {
    var url = "expenses/insertExpense.php?amount=" + expense.expenseDate +
        "&category=" + expense.category +
        "&notes=" + expense.notes +
        "&date=" + expense.expenseDate +
        "&password=" + expense.password;
    final response = await http.get(Uri.parse(serverPath + url));
    print("myLink:" + serverPath + url);
    Navigator.pop(context);

    // Navigator.push(context, MaterialPageRoute(builder: (context) => MyHomePage()));

  }



  // Function to send expense data to PHP backend
  Future<void> _saveExpense() async {
    // Check if all required fields are filled
    if (_selectedDate == null ||
        amountController.text.isEmpty ||
        categoryController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill all required fields')),
      );
      return;
    }

    // Parse amount from text field
    double? amount = double.tryParse(amountController.text);
    if (amount == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter a valid amount')),
      );
      return;
    }

    // Format date for database (YYYY-MM-DD)
    String formattedDate = "${_selectedDate!.year}-${_selectedDate!.month.toString().padLeft(2, '0')}-${_selectedDate!.day.toString().padLeft(2, '0')}";

    // Get category ID from the selected category
    int categoryId = categoryIds[categoryController.text] ?? 1;

    setState(() {
      _isLoading = true; // Show loading indicator
    });

    try {
      // URL of your PHP backend
      var url = Uri.parse('http://your-website.com/path/to/save_expense.php');

      // Prepare data to send
      var response = await http.post(
        url,
        body: {
          'expense_date': formattedDate,
          'amount': amount.toString(),
          'notes': notesController.text,
          'category_id': categoryId.toString(),
          'user_id': widget.userId.toString(),
        },
      );

      // Handle response
      var data = json.decode(response.body);

      setState(() {
        _isLoading = false; // Hide loading indicator
      });

      if (data['result'] == '1') {
        // Success message
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Expense added successfully!')),
        );

        // Clear form fields
        amountController.clear();
        notesController.clear();
        setState(() {
          _selectedDate = DateTime.now();
        });

        // Go back to previous screen after successful save
        Navigator.pop(context, true);
      } else {
        // Error message
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Failed to add expense. Please try again.')),
        );
      }
    } catch (e) {
      setState(() {
        _isLoading = false; // Hide loading indicator
      });

      // Error message for exceptions
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: ${e.toString()}')),
      );
    }
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