class User {
  User({
    this.userID = 0,
    this.firstName = "",
    this.lastName	 = "",
    this.password	 = "",
    this.createdDateTime="",
  });

  int userID;
  String firstName;
  String lastName	;
  String password	;
  String createdDateTime;


  factory User.fromJson(Map<String, dynamic> json) => User(
    userID: json["userID"],
    firstName: json["firstName"],
    lastName	: json["lastName	"],
    password	: json["password	"],
    createdDateTime: json["createdDateTime"],

  );

  Map<String, dynamic> toJson() => {
        "userID": userID,
        "firstName": firstName,
        "lastName	": lastName	,
        "password	": password	,
        "createdDateTime":createdDateTime,
      };
}
