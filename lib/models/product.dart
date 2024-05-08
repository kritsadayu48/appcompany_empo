class Product {
  final String image;
  final String name;
  final String description;
  final int price;
  final int? amount;
  final String category; // เพิ่มฟิลด์ category

  Product({
    required this.image,
    required this.name,
    required this.description,
    required this.price,
    this.amount,
    required this.category,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      image: json['image'],
      name: json['productname'],
      description: json['description'],
      price: double.parse(json['price']).toInt(),
      amount: json['amount'] != null ? int.parse(json['amount'].toString()) : null,
      category: json['category'],
    );
  }
}
