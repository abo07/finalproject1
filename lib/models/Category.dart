class Category {
  Category({
    this.CategoryID = "",
    this.CategoryName = "",

  });

  String CategoryID;
  String CategoryName;



  factory Category.fromJson(Map<String, dynamic> json) => Category(
    CategoryID: json["CategoryID"],
    CategoryName: json["CategoryName"],

  );

  Map<String, dynamic> toJson() => {
        "CategoryID": CategoryID,
        "CategoryName": CategoryName,
      };
}
