import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'editProfile.dart';
import 'expenseScreen.dart';
import 'newExpenseScreen.dart';
import 'package:finalproject1/views/newIncomeScreen.dart';

// Main HomePage class with BottomNavigationBar
class Homepagescreen extends StatefulWidget {
  const Homepagescreen({super.key, required this.title});
  final String title;

  @override
  State<Homepagescreen> createState() => _Homepagescreen();
}

class _Homepagescreen extends State<Homepagescreen> {
  int _selectedIndex = 0; // Default index (Home)

  var total = 2425; // Just an example balance

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text("Home page"),
      ),
      body: _getScreenForIndex(_selectedIndex), // Display selected screen based on index

      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        type: BottomNavigationBarType.fixed,
        onTap: (index) {
          setState(() {
            _selectedIndex = index; // Update selected index
          });
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.money_off),
            label: 'Expenses',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.attach_money),
            label: 'Incomes',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
      ),
    );
  }

  // Helper method to get the correct screen based on index
  Widget _getScreenForIndex(int index) {
    switch (index) {
      case 0:
        return HomePage(); // Home Screen
      case 1:
        return ExpenseScreen(); // Expense Screen
      default:
        return HomePage();
    }
  }
}

// Home Screen (Main screen with balance and buttons)
class HomePage extends StatelessWidget {
  var total = 2425; // Example balance

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        alignment: Alignment.center,
        width: 800,
        child: Column(
          children: <Widget>[
            Text(
              'Current Balance',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            Text(
              '\$ ${total}',
              style: TextStyle(fontSize: 36, fontWeight: FontWeight.w600, color: Colors.green),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => editProfile(title: 'edit')),
                );
              },
              child: Icon(CupertinoIcons.profile_circled),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => newExpenseScreen(title: 'ahmad')),
                );
              },
              child: Text('Add Expense'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => newIncomeScreen(title: 'ahmad')),
                );
              },
              child: Text('Add Income'),
            ),
          ],
        ),
      ),
    );
  }
}