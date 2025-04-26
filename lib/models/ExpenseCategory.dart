// Expense Category data class
import 'dart:ui';

class ExpenseCategory {
  final String name;
  final double amount;
  final Color color;

  ExpenseCategory(this.name, this.amount, this.color);
}



class Category {
  Category({
    this.name = "",
    this.amount = "",
    this.color="",

  });

  String CategoryID;
  String CategoryName;



  factory Category.fromJson(Map<String, dynamic> json) => Category(
    name: json["CategoryID"],
    amount: json["CategoryName"],

  );

  Map<String, dynamic> toJson() => {
    "CategoryID": CategoryID,
    "CategoryName": CategoryName,
  };
}



