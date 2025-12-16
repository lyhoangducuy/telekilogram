

import 'package:dio/dio.dart';

class ApiService {
  final Dio _dio = Dio();
  final String _baseUrl = 'https://dummyjson.com';

  Future<dynamic> getUsers() async {
    try {
      final response = await _dio.get('$_baseUrl/users');

      if (response.statusCode == 200) {
        // Trả về dữ liệu thô hoặc đã được phân tích thành các Model
        return response.data;
      } else {
        throw Exception('Yêu cầu không thành công với mã: ${response.statusCode}');
      }
    } on DioException catch (e) {
      // Xử lý lỗi Dio (lỗi mạng, timeout, v.v.)
      throw Exception('Lỗi kết nối API: $e');
    }
  }
}

// Khởi tạo một thể hiện (instance) để dùng lại
final apiService = ApiService();