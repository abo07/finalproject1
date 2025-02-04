import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'CustomNavigationWidget.dart';
import 'editProfile.dart';
import 'newExpenseScreen.dart';
import 'package:finalproject1/views/newIncomeScreen.dart';

class Homepagescreen extends StatefulWidget {
  const Homepagescreen({super.key, required this.title});
  final String title;

  @override
  State<Homepagescreen> createState() => _HomepagescreenState();  // Fixed name
}

class _HomepagescreenState extends State<Homepagescreen> {  // Fixed name
  var total = 200;
  int selectedIndex = 0;  // Removed asterisk

  // Create a widget for your home content
  Widget _buildHomeContent() {
    return Center(
      child: Container(
        alignment: Alignment.center,
        width: 800,
        child: Column(
          children: <Widget>[
            Text('Current Balance',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
            Text('\$ ${total}',
                style: TextStyle(fontSize: 36, fontWeight: FontWeight.w600, color: Colors.green)),

            ElevatedButton(
                onPressed: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => editProfile(title: 'edit',)));
                },
                child: Icon(CupertinoIcons.profile_circled)
            ),

            ElevatedButton(
              onPressed: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => newExpenseScreen(title: 'ahmad',)));
              },
              child: Text('Add Expense'),
            ),

            ElevatedButton(
              onPressed: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => newIncomeScreen(title: 'ahmad',)));
              },
              child: Text('Add Income'),  // Fixed button text
            ),
          ],
        ),
      ),
    );
  }

  // List of pages using your home content
  final List<Widget> _pages = [];  // Removed asterisk

  @override
  void initState() {
    super.initState();
    _pages.addAll([
      _buildHomeContent(),     // Your current home page content
      Center(child: Text('About Page')),
      Center(child: Text('Contact Page')),
      Center(child: Text('Profile Page')),
    ]);
  }

  void _onItemSelected(int index) {  // Removed asterisk
    setState(() {
      selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text("Home page"),
      ),
      body: _pages[selectedIndex],  // Show the selected page
      bottomNavigationBar: CustomNavigationBar(
        selectedIndex: selectedIndex,
        onItemSelected: _onItemSelected,
      ),
    );
  }
}