class User {
  User({
    this.userID = 0,
    this.firstName = "",
    this.lastName	 = "",
    this.password	 = "",
    this.createdDateTime="",
    this.Email="",
    this.UserName="",
  });

  int userID;
  String firstName;
  String lastName	;
  String password	;
  String Email	;
  String UserName;
  String createdDateTime;


  factory User.fromJson(Map<String, dynamic> json) => User(
    userID: json["userID"],
    firstName: json["firstName"],
    lastName	: json["lastName	"],
    password	: json["password	"],
    Email: json["Email"],
    UserName: json["UserName"],
    createdDateTime: json["createdDateTime"],

  );

  Map<String, dynamic> toJson() => {
        "userID": userID,
        "firstName": firstName,
        "lastName	": lastName	,
        "password	": password	,
        "Email	": Email	,
        "UserName	": UserName	,
        "createdDateTime":createdDateTime,
      };
}
