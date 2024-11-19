class Expense {
  Expense({
    this.expenseID = "",
    this.expenseDate = "",
    this.amount = 0,
    this.notes = "",
    this.catogeryID="",
    this.userID="",
  });

  String expenseID;
  String expenseDate;
  double amount;
  String notes;
  String catogeryID;
  String userID	;



  factory Expense.fromJson(Map<String, dynamic> json) => Expense(
    expenseID: json["expenseId"],
    expenseDate: json["expenseDate"],
    amount: json["amount"],
    notes: json["notes"],
    catogeryID: json["catogeryID"],
    userID: json["userID"],


  );

  Map<String, dynamic> toJson() => {
        "expenseId": expenseID,
        "expenseDate": expenseDate,
        "amount": amount,
        "notes": notes,
        "catogeryID":catogeryID,
         "userID":userID,
      };
}
