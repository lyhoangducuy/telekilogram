import 'package:dio/dio.dart';
import 'package:telekilogram/models/product.dart';

class Api {
  static final Api _singleton = Api._internal();
  factory Api() => _singleton;
  Api._internal();

  final Dio _dio = Dio(BaseOptions(
    baseUrl: 'https://dummyjson.com',
    connectTimeout: const Duration(seconds: 15),
    receiveTimeout: const Duration(seconds: 15),
    headers: {'Content-Type': 'application/json'},
  ));

  Future<Map<String, dynamic>> login(String username, String password) async {
    try {
      final res = await _dio.post(
        '/auth/login',
        data: {'username': username, 'password': password},
      );
      return Map<String, dynamic>.from(res.data as Map);
    } on DioException catch (e) {
      final data = e.response?.data;
      if (data is Map && data['message'] != null) {
        throw Exception(data['message'].toString());
      }
      throw Exception('Đăng nhập thất bại');
    }
  }

  Future<List<Product>> getAllProducts({int limit = 20, int skip = 0}) async {
    try {
      final res = await _dio.get(
        '/products',
        queryParameters: {'limit': limit, 'skip': skip},
      );
      final list = (res.data['products'] as List?) ?? [];
      return list.map((e) => Product.fromJson(e)).toList();
    } on DioException catch (e) {
      throw Exception('Lỗi tải sản phẩm: ${e.message}');
    }
  }

  Future<List<Product>> searchProducts(String q, {int limit = 20, int skip = 0}) async {
    try {
      final res = await _dio.get(
        '/products/search',
        queryParameters: {'q': q, 'limit': limit, 'skip': skip},
      );
      final list = (res.data['products'] as List?) ?? [];
      return list.map((e) => Product.fromJson(e)).toList();
    } on DioException catch (e) {
      throw Exception('Lỗi tìm kiếm: ${e.message}');
    }
  }
  Future<Product> getProductById(int id) async {
  try {
    final res = await _dio.get('/products/$id');
    return Product.fromJson(res.data as Map<String, dynamic>);
  } on DioException catch (e) {
    throw Exception('Lỗi tải chi tiết: ${e.message}');
  }
}

}

final testApi = Api();
