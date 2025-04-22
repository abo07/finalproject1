import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'dart:convert'; // Added for URL encoding
import '../utils/APIconfigue.dart';
import '../utils/utils.dart';

const List<String> categories = <String>['job salary', 'side job', 'gifts', 'buisness'];
// Map category names to IDs (assuming your database uses numeric IDs)
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
  bool _isLoading = false; // Add a loading state
  String responseMessage = ""; // For debugging

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

  Future<void> insertIncome() async {
    try {
      // Format date for database (YYYY-MM-DD)
      String formattedDate = "${_selectedDate!.year}-${_selectedDate!.month.toString().padLeft(2, '0')}-${_selectedDate!.day.toString().padLeft(2, '0')}";

      // Encode notes and category to handle special characters
      String encodedNotes = Uri.encodeComponent(notesController.text);
      String encodedCategory = Uri.encodeComponent(categoryController.text);

      // Build the URL with all the data - exactly like the expense screen
      var url = serverPath + "incomes/insertIncome.php";

      var response = await http.post(
          Uri.parse(url),
          body: {
            'amount': amountController.text,
            'category': categoryController.text,
            'notes': notesController.text,
            'date': formattedDate,
          }
      );

      // Print response for debugging
      print("Response status: ${response.statusCode}");
      print("Response body: ${response.body}");

      setState(() {
        responseMessage = "Status: ${response.statusCode}, Body: ${response.body}";
      });

      // If POST didn't work, try GET as a fallback since your expense screen uses GET
      if (response.statusCode != 200) {
        // Build the URL with all the data - exactly like the expense screen
        url = serverPath + "incomes/insertIncome.php?amount=" + amountController.text +
            "&category=" + encodedCategory +
            "&notes=" + encodedNotes +
            "&date=" + formattedDate;

        response = await http.get(Uri.parse(url));
        print("Trying GET method. Connecting to: " + url);
        print("GET Response status: ${response.statusCode}");
        print("GET Response body: ${response.body}");

        setState(() {
          responseMessage += "\nFallback GET - Status: ${response.statusCode}, Body: ${response.body}";
        });
      }

      // Check response
      if (response.statusCode == 200) {
        // Show success message
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Income added successfully')),
        );
        // Go back to previous screen
        Navigator.pop(context);
      } else {
        // Show error message
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: Unable to save income')),
        );
      }
    } catch (e) {
      print("Error inserting income: $e");
      setState(() {
        responseMessage = "Error: $e";
      });
      // Show error message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    }
  }

  Future<void> _saveIncome() async {
    // Check if required fields are filled
    if (_selectedDate == null || amountController.text.isEmpty || categoryController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill all required fields')),
      );
      return;
    }

    // Validate amount is a number
    if (double.tryParse(amountController.text) == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter a valid amount')),
      );
      return;
    }

    // Show loading spinner
    setState(() {
      _isLoading = true;
      responseMessage = "";
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
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text("New Income"),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            // Debug section - will show response info
            if (responseMessage.isNotEmpty) Container(
              padding: EdgeInsets.all(8),
              color: Colors.amber[100],
              child: Text("Debug: $responseMessage", style: TextStyle(fontSize: 12)),
            ),

            const Text("Income date:", style: TextStyle(fontWeight: FontWeight.bold)),
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
              keyboardType: TextInputType.text,
            ),

            const SizedBox(height: 32),

            Center(
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 12),
                ),
                onPressed: _saveIncome,
                child: const Text('Add Income', style: TextStyle(fontSize: 16)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}