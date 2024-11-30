import 'package:finalproject1/models/User.dart';
import 'package:finalproject1/utils/DB.dart';
import 'package:flutter/material.dart';
import 'package:finalproject1/main.dart';

import '../utils/utils.dart';


class newExpenseScreen extends StatefulWidget {
  const newExpenseScreen({super.key, required this.title});

  final String title;

  @override
  State<newExpenseScreen> createState() => _signUp();
}

class _signUp extends State<newExpenseScreen> {

  final _firstName=TextEditingController();
  final _LastName=TextEditingController();
  final _txtEmail=TextEditingController();
  final _username=TextEditingController();
  final _NewPassword=TextEditingController();
  final _ConfirmPassword=TextEditingController();

  void insertUserFunction()
  {

    var uti =new utils();
    if(_firstName!="" && _txtEmail!="" && _username!="" && _NewPassword!="")
      {
        var user =new User();
        user.firstName=_firstName.text;
        user.Email=_txtEmail.text;
        user.userName=_username.text;
        user.password=_NewPassword.text;
        insertUser(user);
        uti.showMyDialog(context, "SUCCESS!!", "", "");

      }
    else
      {
        var uti =new utils();
        uti.showMyDialog(context, "Reguired", "", "first name and email and username and new password is required");

      }
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
                      var uti1 = new utils();
                      uti1.showMyDialog(context, _firstName.text, _LastName.text,_txtEmail.text);
                      User user2=new User();
                      user2.firstName=_firstName.text;
                      user2.lastName=_LastName.text;
                      user2.password=_txtEmail.text;

                      insertUser(user2);
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
                      User user1=new User();
                      user1.firstName="Ahmad";
                      user1.lastName="AboMokh";
                      user1.password="ahmad3284923";
                      user1.createdDateTime="21/10/2024";
                      insertUserFunction();

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
