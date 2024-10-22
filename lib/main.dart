import 'package:flutter/material.dart';
import 'views/signUpScreen.dart';
import 'views/homePageScreen.dart';

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


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.cyan,
      body: Center(


        child: Container(

          alignment: Alignment.center,
          width: 800,
          child: Column(
            children: <Widget>[

              Text("username"),
              TextField(
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: 'Enter your  username',
                ),
              ),


              Text("Password"),
              TextField(
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
                    child: Text('do not have an account?create an account'),
                  ),

                  const SizedBox(
                    width: 20.0,
                  ),

                  TextButton(
                    style: ButtonStyle(
                      foregroundColor: MaterialStateProperty.all<Color>(Colors.blue),
                    ),
                    onPressed: () {
                      // Navigate to the second screen when the button is pressed
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) => Homepagescreen(title: 'ahmad',)));
                    },
                    child: Text('login'),
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
