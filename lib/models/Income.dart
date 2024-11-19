class Income {
  Income({
    this.incomeID = "",
    this.amount = 0,
    this.incomeDate = "",
    this.notes = "",
    this.userID="",
  });

  String incomeID;
  double amount;
  String incomeDate;
  String notes;
  String userID;


  factory Income.fromJson(Map<String, dynamic> json) => Income(
    incomeID: json["incomeID"],
    amount: json["amount"],
    incomeDate: json["incomeDate"],
    notes: json["notes"],
    userID: json["userID"],

  );

  Map<String, dynamic> toJson() => {
        "incomeID": incomeID,
        "amount": amount,
        "incomeDate": incomeDate,
        "notes": notes,
        "userID":userID,
      };
}
