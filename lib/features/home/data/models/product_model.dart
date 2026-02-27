class ProductModel {
  final String id;
  final String name;
  final double price;
  final double rating;
  final String image;
  final String category;

  ProductModel({
    required this.id,
    required this.name,
    required this.price,
    required this.rating,
    required this.image,
    required this.category,
  });

  factory ProductModel.fromJson(Map<String, dynamic> json) {
    return ProductModel(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      price: (json['price'] ?? 0).toDouble(),
      rating: (json['rating'] ?? 0).toDouble(),
      image: json['image'] ?? '',
      category: json['category'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'price': price,
      'rating': rating,
      'image': image,
      'category': category,
    };
  }
}
