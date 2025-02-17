import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'editProfile.dart';
import 'newExpenseScreen.dart';
import 'package:finalproject1/views/newIncomeScreen.dart';



class Homepagescreen extends StatefulWidget {
  const Homepagescreen({super.key, required this.title});

  final String title;

  @override
  State<Homepagescreen> createState() => _Homepagescreen();
}

class _Homepagescreen extends State<Homepagescreen> {
  int _selectedIndex = 0;

 var total = 2425;//just an example

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text("Home page"),
      ),

      body: Center(
        child: Container(
          alignment: Alignment.center,
          width: 800,
          child: Column(
            children: <Widget>[

              Text('Current Balance', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
              Text('\$ ${total}', style: TextStyle(fontSize: 36, fontWeight: FontWeight.w600, color: Colors.green)),



              ElevatedButton(
                onPressed: () {
                  // Navigate to the second screen when the button is pressed
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => editProfile(title: 'edit',)));
                },
                child: Icon(CupertinoIcons.profile_circled)
              ),

              ElevatedButton(
                onPressed: () {

                  // Navigate to the second screen when the button is pressed
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => newExpenseScreen(title: 'ahmad',)));

                },
                child: Text('Add Expense'),
              ),
              ElevatedButton(
                onPressed: () {

                  // Navigate to the second screen when the button is pressed
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => newIncomeScreen(title: 'ahmad',)));

                },
                child: Text('Add Expense'),
              ),


            ],








          ),
        ),
      ),


      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,  // Add this variable to your state
        type: BottomNavigationBarType.fixed,
        onTap: (index) {
          setState(() {
            _selectedIndex = index;
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
}