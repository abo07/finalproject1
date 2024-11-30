class User {
  User({
    this.userID = 0,
    this.firstName = "",
    this.lastName	 = "",
    this.password	 = "",
    this.createdDateTime="",
    this.Email="",
    this.userName="",
  });

  int userID;
  String firstName;
  String lastName	;
  String password	;
  String Email	;
  String userName;
  String createdDateTime;


  factory User.fromJson(Map<String, dynamic> json) => User(
    userID: json["userID"],
    firstName: json["firstName"],
    lastName	: json["lastName	"],
    password	: json["password	"],
    Email: json["Email"],
    userName: json["UserName"],
    createdDateTime: json["createdDateTime"],

  );

  Map<String, dynamic> toJson() => {
        "userID": userID,
        "firstName": firstName,
        "lastName	": lastName	,
        "password	": password	,
        "Email	": Email	,
        "UserName	": userName	,
        "createdDateTime":createdDateTime,
      };
}
