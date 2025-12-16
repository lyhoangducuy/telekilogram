// lib/models/Product.dart

class Product {
  int id;
  String title;
  dynamic price;
  String description;
  String category;
  String image;
  Rating rating;

  Product({
    required this.id,
    required this.title,
    required this.price,
    required this.description,
    required this.category,
    required this.image,
    required this.rating,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'] ?? 0,
      title: json['title'] ?? '',
      // Giá có thể là int hoặc double, giữ dynamic hoặc chuyển về double/num
      price: json['price'] ?? 0, 
      description: json['description'] ?? '',
      category: json['category'] ?? '',
      image: json['image'] ?? '',
      rating: json['rating'] != null
          ? Rating.fromJson(json['rating'])
          : Rating(rate: 0.0, count: 0),
    );
  }

  // Phương thức toJson không cần thiết cho ứng dụng hiển thị, nhưng tôi giữ lại cho đầy đủ.
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'price': price,
      'description': description,
      'category': category,
      'image': image,
      'rating': rating.toJson(),
    };
  }
}

class Rating {
  double rate;
  int count;

  Rating({
    required this.rate,
    required this.count,
  });

  factory Rating.fromJson(Map<String, dynamic> json) {
    // Ép kiểu an toàn: đảm bảo giá trị luôn là double
    num rateValue = json['rate'] ?? 0;
    return Rating(
      rate: rateValue.toDouble(),   
      count: json['count'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'rate': rate,
      'count': count,
    };
  }
}