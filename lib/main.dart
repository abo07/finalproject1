import 'dart:io';

import 'package:finalproject1/utils/DB.dart';
import 'package:finalproject1/utils/utils.dart';
import 'package:flutter/material.dart';
import 'views/signUpScreen.dart';
import 'views/homePageScreen.dart';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import '../utils/APIconfigue.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {

  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      debugShowCheckedModeBanner: false,
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, });


  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  final TextEditingController _txt1= TextEditingController();
  final TextEditingController _txt2= TextEditingController();

  checkConction() async {
    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        // print('connected to internet');// print(result);// return 1;
      }
    } on SocketException catch (_) {
      // print('not connected to internet');// print(result);
      var uti = new utils();
      uti.showMyDialog(context, "אין אינטרנט", "האפליקציה דורשת חיבור לאינטרנט, נא להתחבר בבקשה","");
      return;
    }
  }

  @override
  Widget build(BuildContext context) {
    checkConction();

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text("ExpenseApp"),
      ),


      body: Center(


        child: Container(

          alignment: Alignment.center,
          width: 800,
          child: Column(
            children: <Widget>[

              Text("username"),
              TextField(
                controller: _txt1,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: 'Enter your  username',
                ),
              ),


              Text("Password ${_txt1.text}"),
              TextField(
                controller: _txt2,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: 'Enter your  Password',
                ),

              ),

              Row(
                children: [
                  const SizedBox(
                    width: 200.0,
                  ),
                  ElevatedButton(
                    onPressed: () {

                      // Navigate to the second screen when the button is pressed
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) => signUp(title: 'ahmad',)));

                    },
                    child: Text('create'),
                  ),

                  const SizedBox(
                    width: 20.0,
                  ),

                  TextButton(
                    style: ButtonStyle(
                      foregroundColor: MaterialStateProperty.all<Color>(Colors.blue),
                    ),
                    onPressed: () {
                       Navigator.push(context, MaterialPageRoute(builder: (context) => Homepagescreen(title: 'ahmad',)));
                      var uti = new utils();
                      uti.showMyDialog(context, _txt1.text, _txt2.text,'ahmad');
                    },
                    child: Text('login'),
                  ),
                ],
              ),

              // utils.showM(_txt1.text, _txt2.text, 'abo mok', context),
            ],
          ),
        ),
      ),



    );
  }
}
