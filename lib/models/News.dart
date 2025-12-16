import 'dart:convert';
import 'package:http/http.dart' as http;

class NewsItem {
  final String title;
  final String shortDesc;
  final String content;
  final String thumbnail;
  final String url;

  NewsItem({
    required this.title,
    required this.shortDesc,
    required this.content,
    required this.thumbnail,
    required this.url,
  });

  factory NewsItem.fromJson(Map<String, dynamic> json) {
    return NewsItem(
      title: json['title'] ?? '',
      shortDesc: json['description'] ?? '',
      content: json['content'] ?? '',
      thumbnail: json['urlToImage'] ?? '',
      url: json['url'] ?? '',
    );
  }
}

class NewsApi {
  static const String _api =
     "https://gnews.io/api/v4/top-headlines?category=general&lang=vi&country=vn&apikey=d42a6ac494669732941e837ad3c76c2d";

  static Future<List<NewsItem>> fetchNews() async {
    final res = await http.get(Uri.parse(_api));

    if (res.statusCode != 200) {
      throw Exception('Không tải được tin');
    }

    final data = jsonDecode(res.body);
    final List list = data['articles'];

    return list.map((e) => NewsItem.fromJson(e)).toList();
  }
}
