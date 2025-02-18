import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; // Import this for TextInputFormatter
import '../utils/utils.dart';

const List<String> list = <String>['Housing', 'Transportation', 'Food', 'Health & Insurance','Debt & Loans','Savings & Investments','Gifts & Donations'];

class newExpenseScreen extends StatefulWidget {
  const newExpenseScreen({super.key, required this.title});

  final String title;

  @override
  State<newExpenseScreen> createState() => _signUp();
}

class _signUp extends State<newExpenseScreen> {
  DateTime? _selectedDate;
  TextEditingController quantityController = TextEditingController();

  get selectedItem => null;

  // Function to display the date picker
  Future<void> _pickDate(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(), // Default to the current date
      firstDate: DateTime(2000), // Earliest selectable date
      lastDate: DateTime(2100), // Latest selectable date
    );

    if (pickedDate != null && pickedDate != _selectedDate) {
      setState(() {
        _selectedDate = pickedDate;
      });
    }
  }

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed
    quantityController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text("new expense"),
      ),
      body: Center(
        child: Container(
          alignment: Alignment.center,
          width: MediaQuery.of(context).size.width,
          child: Column(
            children: <Widget>[
              Text("Expense date:"),
              Text(
                _selectedDate == null
                    ? 'No date selected'
                    : 'Selected Date: ${_selectedDate!.toLocal()}'
                    .split(' ')[0],
                style: TextStyle(fontSize: 20),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () => _pickDate(context),
                child: Text('Pick a Date'),
              ),
              Text("choose category"),

              DropdownMenu<String>(
                initialSelection: list.first,
                onSelected: (String? value) {
                  setState(() {
                    var dropdownValue = value!;
                  });
                },
                dropdownMenuEntries:
                list.map<DropdownMenuEntry<String>>((String value) {
                  return DropdownMenuEntry<String>(value: value, label: value);
                }).toList(),
              ),
              Text(" quantity:"),
              TextField(
                controller: quantityController,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: 'Enter quantity',
                ),
                keyboardType: TextInputType.number, // Set keyboard to numeric
                inputFormatters: <TextInputFormatter>[
                  FilteringTextInputFormatter.digitsOnly, // Only accept digits
                  // Alternatively, use this for decimal numbers:
                  // FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,2}')),
                ],
              ),
              ElevatedButton(
                onPressed: () {
                  // Now you can safely parse the quantity as a number
                  double? quantity = double.tryParse(quantityController.text);
                  if (quantity != null) {
                    // Add your logic here
                  } else {
                    // Show error that the input is not a valid number
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Please enter a valid number')),
                    );
                  }
                },
                child: Text('Add Expense '),
              ),
            ],
          ),
        ),
      ),
    );
  }
}