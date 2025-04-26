import 'dart:ui';

import 'package:flutter/material.dart';

class ExpenseCategory {
  final String name;
  final int amount;
  final Color color;

  ExpenseCategory(this.name, this.amount, this.color);

  factory ExpenseCategory.fromJson(Map<String, dynamic> json) {
    // Parse color string to actual Color object
    Color getColorFromString(String colorStr) {
      switch(colorStr.toLowerCase()) {
        case 'red': return Colors.red;
        case 'green': return Colors.green;
        case 'blue': return Colors.blue;
      // Add more colors as needed
        default: return Colors.grey;
      }
    }

    return ExpenseCategory(
        json['name'] ?? 'Unknown',
        int.tryParse(json['amount'].toString()) ?? 0,
        json['color'] != null ? getColorFromString(json['color']) : Colors.grey
    );
  }
}