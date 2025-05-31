import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../utils/APIconfigue.dart';
import 'package:http/http.dart' as http;

class GoalScreen extends StatefulWidget {
  const GoalScreen({super.key, required this.title});

  final String title;

  @override
  State<GoalScreen> createState() => _GoalScreenState();
}

class _GoalScreenState extends State<GoalScreen> {
  List<dynamic> _Goals = [];
  bool _isLoading = true;
  String _errorMessage = '';


  final TextEditingController _goalNameController = TextEditingController();
  final TextEditingController _targetAmountController = TextEditingController();
  final TextEditingController _currentAmountController = TextEditingController();

  @override
  void initState() {
    super.initState();
    fetchGoals();
  }


  void _updateGoalProgress(int index) {
    showDialog(
      context: context,
      builder: (context) {
        final TextEditingController updateController = TextEditingController();
        return AlertDialog(
          title: Text('Update Progress'),
          content: TextField(
            controller: updateController,
            decoration: InputDecoration(
              labelText: 'Current Amount',
              hintText: 'Enter the current amount',
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () async {
                if (updateController.text.isNotEmpty) {

                  await addAmountGoalInDatabase(
                      _Goals[index]['goalID'],
                      double.parse(updateController.text)
                  );

                  fetchGoals();
                  Navigator.of(context).pop();
                }
              },
              child: Text('Update'),
            ),
          ],
        );
      },
    );
  }

  Future<void> addAmountGoalInDatabase(int goalId, double newAmount) async {
print("dddd");

    SharedPreferences prefs = await SharedPreferences.getInstance();
    var userID = prefs.getInt("userID");

    var url = serverPath + "goals/addAmount.php?goalID=" + goalId.toString() +
        "&userID=" + userID.toString() + "&addedAmount=" +newAmount.toString() ;

    print("Updating goal: " + url);

    final response = await http.get(Uri.parse(url));
    print("Response status: ${response.statusCode}");
    print("Response body: ${response.body}");
  }

  Future<void> insertGoal() async {
    if (_goalNameController.text.isEmpty || _targetAmountController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Please fill in required fields'))
      );
      return;
    }


    SharedPreferences prefs = await SharedPreferences.getInstance();
    var userID = prefs.getInt("userID");


    var url = serverPath + "goals/insertGoal.php?targetAmount=" + _targetAmountController.text +
        "&goalName=" + _goalNameController.text +
        "&paid=" + (_currentAmountController.text.isEmpty ? "0" : _currentAmountController.text) +
        "&userID=" + userID.toString();

    print("Connecting to: " + url);


    final response = await http.get(Uri.parse(url));





    _goalNameController.clear();
    _targetAmountController.clear();
    _currentAmountController.clear();

    fetchGoals();


    ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Goal added successfully'))
    );
  }

  Future<void> fetchGoals() async {
    setState(() {
      _isLoading = true;
      _errorMessage = '';
    });

    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      var userID = prefs.getInt("userID");

      var url = "goals/getGoals.php?userID=" + userID.toString();
      print(serverPath + url);
      final response = await http.get(Uri.parse(serverPath + url));

      if (response.statusCode == 200) {

        print("API Response: ${response.body}");

        if (response.body.isNotEmpty) {

          final jsonData = json.decode(response.body);
          setState(() {
            _Goals = jsonData;
            _isLoading = false;
          });
        } else {
          setState(() {
            _Goals = [];
            _isLoading = false;
          });
        }
      } else {
        setState(() {
          _errorMessage = 'Failed to load Goals. Status: ${response.statusCode}';
          _isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        _errorMessage = 'Error: $e';
        _isLoading = false;
      });
      print("Exception while fetching goals: $e");
    }
  }


  @override
  void dispose() {
    _goalNameController.dispose();
    _targetAmountController.dispose();
    _currentAmountController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Container(
          alignment: Alignment.center,
          width: 800,
          child: _isLoading
              ? Center(child: CircularProgressIndicator())
              : _errorMessage.isNotEmpty
              ? Center(child: Text(_errorMessage, style: TextStyle(color: Colors.red)))
              : SingleChildScrollView(
            padding: EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[

                Card(
                  elevation: 4,
                  child: Padding(
                    padding: EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Text(
                          'Add New Goal',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 16),
                        TextField(
                          controller: _goalNameController,
                          decoration: InputDecoration(
                            labelText: 'Goal Name',
                            hintText: 'e.g. New Car, Emergency Fund',
                            border: OutlineInputBorder(),
                          ),
                        ),
                        SizedBox(height: 10),
                        TextField(
                          controller: _targetAmountController,
                          decoration: InputDecoration(
                            labelText: 'Target Amount',
                            hintText: 'e.g. 5000',
                            border: OutlineInputBorder(),
                          ),
                          keyboardType: TextInputType.number,
                        ),
                        SizedBox(height: 10),
                        TextField(
                          controller: _currentAmountController,
                          decoration: InputDecoration(
                            labelText: 'Starting Amount (Optional)',
                            hintText: 'e.g. 1000',
                            border: OutlineInputBorder(),
                          ),
                          keyboardType: TextInputType.number,
                        ),
                        SizedBox(height: 16),
                        ElevatedButton(
                          onPressed: insertGoal,
                          child: Text('Add Goal'),
                          style: ElevatedButton.styleFrom(
                            padding: EdgeInsets.symmetric(vertical: 12),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                SizedBox(height: 24),

                // Goals list
                Text(
                  'Your Goals',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 8),


                _Goals.isEmpty
                    ? Center(
                  child: Padding(
                    padding: EdgeInsets.all(32.0),
                    child: Text(
                      'No goals yet. Add your first financial goal above!',
                      style: TextStyle(color: Colors.grey),
                      textAlign: TextAlign.center,
                    ),
                  ),
                )
                    : ListView.builder(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  itemCount: _Goals.length,
                  itemBuilder: (context, index) {
                    final goal = _Goals[index];

                    final double targetAmount = double.parse(goal['targetAmount'].toString());
                    final double currentAmount = double.parse(goal['paid'].toString());
                    final double progress = targetAmount > 0 ? (currentAmount / targetAmount) : 0.0;

                    return Card(
                      margin: EdgeInsets.only(bottom: 12),
                      child: Padding(
                        padding: EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                  child: Text(
                                    goal['goalName'] ?? 'Unnamed Goal',
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                    ),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                                IconButton(
                                  icon: Icon(Icons.add),
                                  onPressed: () => _updateGoalProgress(index),
                                  tooltip: 'Update progress',

                                ),
                              ],
                            ),
                            SizedBox(height: 6),
                            Text(
                              '\$${currentAmount.toStringAsFixed(2)} of \$${targetAmount.toStringAsFixed(2)}',
                              style: TextStyle(color: Colors.grey[700]),
                            ),
                            SizedBox(height: 12),
                            LinearProgressIndicator(
                              value: progress.clamp(0.0, 1.0),
                              backgroundColor: Colors.grey[300],
                              valueColor: AlwaysStoppedAnimation<Color>(
                                progress >= 1.0 ? Colors.green : Colors.blue,
                              ),
                              minHeight: 10,
                            ),
                            SizedBox(height: 8),
                            Text(
                              '${(progress * 100).toStringAsFixed(1)}% Complete',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: progress >= 1.0 ? Colors.green : Colors.blue,
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}