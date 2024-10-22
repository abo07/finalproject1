import 'package:flutter/material.dart';
import 'package:finalproject1/main.dart';


class signUp extends StatefulWidget {
  const signUp({super.key, required this.title});

  final String title;

  @override
  State<signUp> createState() => _signUp();
}

class _signUp extends State<signUp> {


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Container(
          alignment: Alignment.center,
          width: 800,
          child: Column(
            children: <Widget>[

              Text("first name:"),
              TextField(
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: 'Enter your first name',
                ),
              ),
              Text("last name:"),
              TextField(
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: 'Enter your last name',
                ),
              ),
              Text("Email:"),
              TextField(
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: 'Enter your Email',
                ),
              ),

              Text("username"),
              TextField(
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: 'Enter your New username',
                ),
              ),

              Text("New Password"),
              TextField(
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: 'Enter your New Password',
                ),
              ),

              Text("Confirm New Password"),
              TextField(
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: 'Enter your New Password',
                ),
              ),

              Row(
                children: [
                  const SizedBox(
                    width: 200.0,
                  ),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.push(context, MaterialPageRoute(builder: (context) => MyHomePage()));
                    },
                    child: Text('create account'),
                  ),

                  const SizedBox(
                    width: 20.0,
                  ),

                  TextButton(
                    style: ButtonStyle(
                      foregroundColor: MaterialStateProperty.all<Color>(Colors.blue),
                    ),
                    onPressed: () {
                      Navigator.push(context, MaterialPageRoute(builder: (context) => MyHomePage()));
                      },
                    child: Text('Already have an account ? login.'),
                  ),
                ],
              ),

            ],


          ),
        ),
      ),
    );
  }
}
