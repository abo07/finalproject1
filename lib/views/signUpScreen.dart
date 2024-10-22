import 'package:flutter/material.dart';
import 'package:finalproject1/main.dart';


class signUp extends StatefulWidget {
  const signUp({super.key, required this.title});

  final String title;

  @override
  State<signUp> createState() => _signUp();
}

class _signUp extends State<signUp> {

  final _firstName=TextEditingController();
  final _LastName=TextEditingController();
  final _txtEmail=TextEditingController();
  final _username=TextEditingController();
  final _NewPassword=TextEditingController();
  final _ConfirmPassword=TextEditingController();



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
                controller: _firstName,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: 'Enter your first name',
                ),
              ),
              Text("last name:"),
              TextField(
                controller: _LastName,

                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: 'Enter your last name',
                ),
              ),
              Text("Email:"),
              TextField(
                controller: _txtEmail,

                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: 'Enter your Email',
                ),
              ),

              Text("username"),
              TextField(
                controller: _username,

                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: 'Enter your New username',
                ),
              ),

              Text("New Password"),
              TextField(
                controller: _NewPassword,

                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: 'Enter your New Password',
                ),
              ),

              Text("Confirm New Password"),
              TextField(
                controller: _ConfirmPassword,

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

                  const SizedBox(
                    width: 20.0,
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
