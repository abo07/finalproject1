import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:fl_chart/fl_chart.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../utils/APIconfigue.dart';

class ExpensesChartPage extends StatefulWidget {
  @override
  _ExpensesChartPageState createState() => _ExpensesChartPageState();
}

class _ExpensesChartPageState extends State<ExpensesChartPage> {
  List<dynamic> _data = [];

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  Future<void> fetchData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var userID = prefs.getInt("userID");    var url = "ExpenseCategory/getReports.php?userID=" + userID.toString();
    final response = await http.get(Uri.parse(serverPath + url));

    if (response.statusCode == 200) {
      setState(() {
        _data = json.decode(response.body);
      });
    } else {
      print('Failed to load data');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Expenses & Incomes')),
      body: _data.isEmpty
          ? Center(child: CircularProgressIndicator())
          : Padding(
        padding: const EdgeInsets.all(16.0),
        child: PieChart(
          PieChartData(
            sections: _data.map((item) {
              final value = item['amount'].toDouble();
              final title = item['category'];
              return PieChartSectionData(
                value: value,
                title: title,
                radius: 80,
                titleStyle: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.white),
              );
            }).toList(),
            sectionsSpace: 2,
            centerSpaceRadius: 40,
          ),
        ),
      ),
    );
  }
}