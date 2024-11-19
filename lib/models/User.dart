class User {
  User({
    this.id = "",
    this.name = "",
    this.phone = "",
    this.note = "",
    this.address="",
  });

  String id;
  String name;
  String phone;
  String note;
  String address;


  factory User.fromJson(Map<String, dynamic> json) => User(
        id: json["id"],
        name: json["name"],
        phone: json["phone"],
        note: json["note"],
        address: json["address"],

  );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "phone": phone,
        "note": note,
        "address":address,
      };
}
