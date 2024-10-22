import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'editProfile.dart';

class Homepagescreen extends StatefulWidget {
  const Homepagescreen({super.key, required this.title});

  final String title;

  @override
  State<Homepagescreen> createState() => _Homepagescreen();
}

class _Homepagescreen extends State<Homepagescreen> {



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Container(
          alignment: Alignment.center,
          width: 800,
          child: Column(
            children: <Widget>[

              ElevatedButton(
                onPressed: () {
                  // Navigate to the second screen when the button is pressed
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => editProfile(title: 'edit',)));
                },
                child: Icon(CupertinoIcons.profile_circled)
              ),            ],


          ),
        ),
      ),



    );
  }
}