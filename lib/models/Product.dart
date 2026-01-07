class Product {
  final int id;
  final String title;
  final String description;
  final num price;
  final String thumbnail;
  final String category;

  // thêm cho detail
  final List<String> images;
  final String brand;
  final num rating;

  Product({
    required this.id,
    required this.title,
    required this.description,
    required this.price,
    required this.thumbnail,
    required this.category,
    required this.images,
    required this.brand,
    required this.rating,
  });

  factory Product.fromJson(Map<String, dynamic> json) => Product(
        id: json['id'] ?? 0,
        title: json['title'] ?? '',
        description: json['description'] ?? '',
        price: json['price'] ?? 0,
        thumbnail: json['thumbnail'] ?? '',
        category: json['category'] ?? '',
        images: (json['images'] is List)
            ? (json['images'] as List).map((e) => e.toString()).toList()
            : <String>[],
        brand: (json['brand'] ?? '').toString(),
        rating: json['rating'] ?? 0,
      );
}
