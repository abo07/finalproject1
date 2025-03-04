import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/Expense.dart';
import '../utils/APIconfigue.dart';
import 'newExpenseScreen.dart';
import 'package:http/http.dart' as http;




// Expense Screen
class ExpenseScreen extends StatelessWidget {


  Future getMyLocations() async {

    var url = "expenses/getExpenses.php";
    final response = await http.get(Uri.parse(serverPath + url));
    print(serverPath + url);
    List<Expense> arr = [];

    for(Map<String, dynamic> i in json.decode(response.body)){
      arr.add(Expense.fromJson(i));
    }

    return arr;
  }



  @override

  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
    title: Text("Edit profile"),
    ),

    body: FutureBuilder(
      future: getMyLocations(),
      builder: (context, projectSnap) {
        if (projectSnap.hasData) {
          if (projectSnap.data.length == 0)
          {
            return SizedBox(
              height: MediaQuery.of(context).size.height * 2,
              child: Align(
                  alignment: Alignment.center,
                  child: Text('אין תוצאות', style: TextStyle(fontSize: 23, color: Colors.black))
              ),
            );
          }
          else {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[


                Expanded(
                    child:ListView.builder(
                      itemCount: projectSnap.data.length,
                      itemBuilder: (context, index) {
                        Expense project = projectSnap.data[index];

                        return Card(
                            child: ListTile(
                              onTap: () {


                              },
                              title: Text(project.expenseDate!, style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black),), // Icon(Icons.timer),
                              // subtitle: Text("[" + project.ariveHour! + "-" + project.exitHour! + "]" + "\n" + project.comments!, style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black),),
                              isThreeLine: false,
                            ));
                      },
                    )),
              ],
            );
          }
        }
        else if (projectSnap.hasError)
        {
          print(projectSnap.error);
          return  Center(child: Text('שגיאה, נסה שוב', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)));
        }
        return Center(child: new CircularProgressIndicator(color: Colors.red,));
      },
    ),

    );
  }
}

    // Sample expense data
    /*
    final List<Expense> expenses = [
      Expense(
        id: '1',
        title: 'Groceries',
        amount: 45.99,
        date: DateTime.now().subtract(const Duration(days: 1)),
      ),
      Expense(
        id: '2',
        title: 'Movie Tickets',
        amount: 28.50,
        date: DateTime.now().subtract(const Duration(days: 3)),
      ),
      Expense(
        id: '3',
        title: 'Gas',
        amount: 35.00,
        date: DateTime.now().subtract(const Duration(days: 5)),
      ),
      Expense(
        id: '4',
        title: 'Dinner',
        amount: 85.75,
        date: DateTime.now().subtract(const Duration(days: 2)),
      ),
    ];
     */
/*
    final formatter = NumberFormat.currency(symbol: '\$');
    final dateFormatter = DateFormat.yMd();

    return Column(
      children: [
        const SizedBox(height: 10),
        const Text(
          'Your Expenses',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 10),
        Expanded(
          child: expenses.isEmpty
              ? const Center(
            child: Text(
              'No Expenses Available',
              style: TextStyle(fontSize: 18, color: Colors.grey),
            ),
          )
              : ListView.builder(
            itemCount: expenses.length,
            itemBuilder: (context, index) {
              final expense = expenses[index];
              return Card(
                margin: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            expense.title,
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            dateFormatter.format(expense.date),
                            style: TextStyle(
                              color: Colors.grey.shade600,
                            ),
                          ),
                        ],
                      ),
                      Text(
                        formatter.format(expense.amount),
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
 */
    /*
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: ElevatedButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => newExpenseScreen(title: 'New Expense')),
              );
            },
            child: const Text('Add New Expense'),
            style: ElevatedButton.styleFrom(
              minimumSize: Size(double.infinity, 50),
            ),
          ),
        ),

     */
      // ],
