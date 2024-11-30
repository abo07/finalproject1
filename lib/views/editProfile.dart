import 'package:flutter/material.dart';


class editProfile extends StatefulWidget {
  const editProfile({super.key, required this.title});

  final String title;

  @override
  State<editProfile> createState() => _editProfile();
}

class _editProfile extends State<editProfile> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text("Edit profile"),
      ),

      body: Center(
        child: Container(
          alignment: Alignment.center,
          width: 800,
          child: Column(
            children: <Widget>[

              Text("this an edit page "),

            ],


          ),
        ),
      ),


    );
  }
}