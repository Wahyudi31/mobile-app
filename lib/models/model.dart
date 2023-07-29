// To parse this JSON data, do
//
// final user = userFromJson(jsonString);
import 'dart:convert';

List<Product> ProductFromJson(String str) =>
    List<Product>.from(json.decode(str).map((x) => Product.fromJson(x)));

String ProductToJson(List<Product> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Product {
  Product({
    required this.id,
    required this.name,
    required this.price,
    required this.desk,
    required this.category,
    required this.image,
    required this.url,
  });

  int id;
  String name;
  int price;
  String desk;
  String category;
  String image;
  String url;

  factory Product.fromJson(Map<String, dynamic> json) => Product(
        id: json["id"],
        name: json["name"],
        price: json["price"],
        desk: json["desk"],
        category: json["category"],
        image: json["image"],
        url: json["url"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "price": price,
        "desk": desk,
        "category": category,
        "image": image,
        "url": url,
      };
}
