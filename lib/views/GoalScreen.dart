import 'package:flutter/material.dart';

class GoalScreen extends StatefulWidget {
  const GoalScreen({super.key, required this.title});

  final String title;

  @override
  State<GoalScreen> createState() => _GoalScreenState();
}

class _GoalScreenState extends State<GoalScreen> {
  // List to store financial goals
  final List<FinancialGoal> goals = [];

  // Controllers for text fields
  final TextEditingController _goalNameController = TextEditingController();
  final TextEditingController _targetAmountController = TextEditingController();
  final TextEditingController _currentAmountController = TextEditingController();

  // Method to add a new goal
  void _addGoal() {
    if (_goalNameController.text.isNotEmpty &&
        _targetAmountController.text.isNotEmpty) {
      setState(() {
        goals.add(FinancialGoal(
          name: _goalNameController.text,
          targetAmount: double.parse(_targetAmountController.text),
          currentAmount: double.parse(_currentAmountController.text.isEmpty ? '0' : _currentAmountController.text),
        ));

        // Clear the text fields
        _goalNameController.clear();
        _targetAmountController.clear();
        _currentAmountController.clear();
      });
    }
  }

  // Method to update progress for a goal
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
            keyboardType: TextInputType.number,
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                if (updateController.text.isNotEmpty) {
                  setState(() {
                    goals[index].currentAmount = double.parse(updateController.text);
                  });
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
      appBar: AppBar(
        title: Text('Financial Goals'),
        backgroundColor: Colors.blue,
      ),
      body: Center(
        child: Container(
          alignment: Alignment.center,
          width: 800,
          child: SingleChildScrollView(
            padding: EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                // Goal entry form
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
                          onPressed: _addGoal,
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

                // Display goals or a message if no goals exist
                goals.isEmpty
                    ? Center(
                  child: Padding(
                    padding: EdgeInsets.all(32.0),
                    child: Text(
                        ' No goals yet. Add your first financial goal above!',
                      style: TextStyle(color: Colors.grey),
                      textAlign: TextAlign.center,
                    ),
                  ),
                )
                    : ListView.builder(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  itemCount: goals.length,
                  itemBuilder: (context, index) {
                    final goal = goals[index];
                    final progress = goal.currentAmount / goal.targetAmount;

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
                                Text(
                                  goal.name,
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                IconButton(
                                  icon: Icon(Icons.edit),
                                  onPressed: () => _updateGoalProgress(index),
                                  tooltip: 'Update progress',
                                ),
                              ],
                            ),
                            SizedBox(height: 6),
                            Text(
                              '\$${goal.currentAmount.toStringAsFixed(2)} of \$${goal.targetAmount.toStringAsFixed(2)}',
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

// Model class for a financial goal
class FinancialGoal {
  String name;
  double targetAmount;
  double currentAmount;

  FinancialGoal({
    required this.name,
    required this.targetAmount,
    this.currentAmount = 0,
  });
}