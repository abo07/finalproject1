import 'dart:convert';
import 'dart:io';
import 'package:finalproject1/utils/DB.dart';
import 'package:finalproject1/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'models/CheckLogin.dart';
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

  final TextEditingController _txtUserName= TextEditingController();
  final TextEditingController _txtPassword= TextEditingController();


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
                controller: _txtUserName,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: 'Enter your  username',
                ),
              ),


              Text("Password"),
              TextField(
                controller: _txtPassword,
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
                      checkLogin();
                      /*
                       Navigator.push(context, MaterialPageRoute(builder: (context) => Homepagescreen(title: 'ahmad',)));
                      var uti = new utils();
                      uti.showMyDialog(context, _txt1.text, _txt2.text,'ahmad');
                       */
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


  Future checkLogin() async {
    var url = "checkLogin/checkLogin.php?userName=" + _txtUserName.text +
        "&password=" + _txtPassword.text;
    final response = await http.get(Uri.parse(serverPath + url));
    print("myLink:" + serverPath + url);
    //Navigator.pop(context);
    print("fff");
    if(checkLoginModel.fromJson(jsonDecode(response.body)).userID == "0")
    {
      // return 'ת.ז ו/או הסיסמה שגויים';
      var uti = new utils();
      uti.showMyDialog(context, "", '', 'ת.ז ו/או הסיסמה שגויים');

    }
    else
    {
      // print("SharedPreferences 1");
      SharedPreferences prefs = await SharedPreferences.getInstance();
      print("1");
      await prefs.setInt('userID', checkLoginModel.fromJson(jsonDecode(response.body)).userID!);
      print("1");
      await prefs.setString('fullName', checkLoginModel.fromJson(jsonDecode(response.body)).fullName!);
      print("1");
      Navigator.push(context, MaterialPageRoute(builder: (context) => Homepagescreen(title: 'ahmad',)));

      // return null;
    }

    // Navigator.push(context, MaterialPageRoute(builder: (context) => MyHomePage()));

  }

}