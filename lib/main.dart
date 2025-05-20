import 'dart:convert';
import 'dart:io';
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
      title: 'ExpenseApp',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
      debugShowCheckedModeBanner: false,
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final TextEditingController _txtUserName = TextEditingController();
  final TextEditingController _txtPassword = TextEditingController();
  bool _isPasswordVisible = false;
  bool _isLoading = false;

  checkConction() async {
    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        // Connected to internet
      }
    } on SocketException catch (_) {
      var uti = new utils();
      uti.showMyDialog(context, "אין אינטרנט", "האפליקציה דורשת חיבור לאינטרנט, נא להתחבר בבקשה", "");
      return;
    }
  }

  Future checkLogin() async {
    setState(() {
      _isLoading = true;
    });

    var url = "checkLogin/checkLogin.php?userName=" + _txtUserName.text +
        "&password=" + _txtPassword.text;
    final response = await http.get(Uri.parse(serverPath + url));

    setState(() {
      _isLoading = false;
    });

    if (checkLoginModel.fromJson(jsonDecode(response.body)).userID == "0") {
      var uti = new utils();
      uti.showMyDialog(context, "", '', 'Username or password is incorrect');
    } else {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setInt('userID', checkLoginModel.fromJson(jsonDecode(response.body)).userID!);
      await prefs.setString('fullName', checkLoginModel.fromJson(jsonDecode(response.body)).fullName!);
      Navigator.push(context, MaterialPageRoute(builder: (context) => Homepagescreen(title: 'ExpenseApp')));
    }
  }

  @override
  Widget build(BuildContext context) {
    checkConction();

    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  // App Logo/Icon
                  Icon(
                    Icons.account_balance_wallet,
                    size: 80,
                    color: Colors.blue,
                  ),

                  SizedBox(height: 16),

                  // Tagline
                  Text(
                    "Manage your finances with ease",
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey[600],
                    ),
                  ),

                  SizedBox(height: 40),

                  // Username Field
                  TextField(
                    controller: _txtUserName,
                    decoration: InputDecoration(
                      labelText: 'Username',
                      hintText: 'Enter your username',
                      prefixIcon: Icon(Icons.person),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      contentPadding: EdgeInsets.symmetric(vertical: 16),
                    ),
                    keyboardType: TextInputType.text,
                  ),

                  SizedBox(height: 16),

                  // Password Field
                  TextField(
                    controller: _txtPassword,
                    obscureText: !_isPasswordVisible,
                    decoration: InputDecoration(
                      labelText: 'Password',
                      hintText: 'Enter your password',
                      prefixIcon: Icon(Icons.lock),
                      suffixIcon: IconButton(
                        icon: Icon(
                          _isPasswordVisible ? Icons.visibility : Icons.visibility_off,
                          color: Colors.grey,
                        ),
                        onPressed: () {
                          setState(() {
                            _isPasswordVisible = !_isPasswordVisible;
                          });
                        },
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      contentPadding: EdgeInsets.symmetric(vertical: 16),
                    ),
                  ),

                  SizedBox(height: 30),

                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton(
                      onPressed: _isLoading ? null : checkLogin,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        elevation: 0,
                      ),
                      child: _isLoading
                          ? SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                        ),
                      )
                          : Text(
                        'Login',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),

                  SizedBox(height: 24),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Don't have an account?",
                        style: TextStyle(
                          color: Colors.grey[600],
                        ),
                      ),
                      SizedBox(width: 4),
                      TextButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => signUp(title: 'Sign Up')),
                          );
                        },
                        child: Text(
                          'Create Account',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.blue,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}