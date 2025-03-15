// In a file called incomeScreen.dart
import 'package:flutter/material.dart';

class incomeScreen extends StatefulWidget {
  final String title;

  const incomeScreen({required this.title});

  @override
  _incomeScreenState createState() => _incomeScreenState();
}

class _incomeScreenState extends State<incomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text("This is the Income Screen6: ${widget.title}"),
    );
  }
}