import 'package:dio/dio.dart';
import 'package:telekilogram/models/product.dart';
// import 'package:baihoc/models/user_model.dart'; // Nếu bạn có User Model

class Api {
  // Singleton Pattern
  static final Api _singleton = Api._internal();
  factory Api() {
    return _singleton;
  }
  Api._internal();
  
  final Dio _dio = Dio();
  final String _baseUrl = 'https://dummyjson.com';
  final String _fakestoreUrl = 'https://fakestoreapi.com';

  // --- 1. CHỨC NĂNG SẢN PHẨM ---
  Future<List<Product>> getAllProducts() async {
    final url = '$_fakestoreUrl/products';
    
    try {
      final response = await _dio.get(url); 

      if (response.statusCode == 200) {
        List data = response.data as List; 
        return data.map((json) => Product.fromJson(json)).toList();
      } else {
        throw Exception('Yêu cầu sản phẩm không thành công. Mã: ${response.statusCode}');
      }
      
    } on DioException catch (e) {
      print('Lỗi gọi API Sản phẩm: $e');
      throw Exception('Không thể kết nối đến server sản phẩm: ${e.message}');
    }
  }

  // --- 2. CHỨC NĂNG NGƯỜI DÙNG MỚI ---
  Future<dynamic> getUsers() async {
    final url = '$_baseUrl/users';
    
    try {
      final response = await _dio.get(url); 

      if (response.statusCode == 200) {
        // API dummyjson trả về một đối tượng chứa mảng 'users'.
        // Bạn có thể phân tích thành User Model hoặc trả về dữ liệu thô.
        return response.data; 
        
        /* // Ví dụ nếu bạn có User Model:
        List userList = response.data['users'] as List;
        return userList.map((json) => UserModel.fromJson(json)).toList();
        */
        
      } else {
        throw Exception('Yêu cầu người dùng không thành công. Mã: ${response.statusCode}');
      }
      
    } on DioException catch (e) {
      print('Lỗi gọi API Người dùng: $e');
      throw Exception('Không thể kết nối đến server người dùng: ${e.message}');
    }
  }

  // --- 3. ĐĂNG NHẬP ---
  /// Đăng nhập bằng username/password sử dụng dummyjson
  /// Trả về Map chứa token và thông tin người dùng nếu thành công
  Future<Map<String, dynamic>> login(String username, String password) async {
    final url = '$_baseUrl/auth/login';

    try {
      // Ensure we send JSON and read server error messages for 4xx responses
      final response = await _dio.post(
        url,
        data: {
          'username': username,
          'password': password,
        },
        options: Options(
          contentType: Headers.jsonContentType,
        ),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        return Map<String, dynamic>.from(response.data as Map);
      } else {
        // If the user provided an email instead of a username, try to
        // resolve the email to a username using the users search endpoint,
        // then retry login with the resolved username.
        if (username.contains('@')) {
          try {
            final searchUrl = '$_baseUrl/users/search?q=$username';
            final searchResp = await _dio.get(searchUrl);
            // dummyjson returns { users: [...] }
            final sdata = searchResp.data;
            if (sdata is Map && sdata['users'] is List && (sdata['users'] as List).isNotEmpty) {
              final found = (sdata['users'] as List).first;
              final resolvedUsername = found['username'] as String?;
              if (resolvedUsername != null && resolvedUsername.isNotEmpty) {
                // retry login with resolved username
                final retryResp = await _dio.post(
                  url,
                  data: {
                    'username': resolvedUsername,
                    'password': password,
                  },
                  options: Options(contentType: Headers.jsonContentType),
                );

                if (retryResp.statusCode == 200 || retryResp.statusCode == 201) {
                  return Map<String, dynamic>.from(retryResp.data as Map);
                }
                final rdata = retryResp.data;
                if (rdata is Map && rdata.containsKey('message')) {
                  throw Exception('Đăng nhập thất bại: ${rdata['message']}');
                }
              }
            }
          } catch (_) {
            // ignore and fall through to throw the original error below
          }
        }

        // Try to surface server-provided error message
        final data = response.data;
        if (data is Map && data.containsKey('message')) {
          throw Exception('Đăng nhập thất bại: ${data['message']}');
        }
        throw Exception('Đăng nhập thất bại. Mã: ${response.statusCode}');
      }
    } on DioException catch (e) {
      // If server responded with a non-2xx status, try to extract its message
      if (e.response != null) {
        final respData = e.response?.data;
        if (respData is Map && respData.containsKey('message')) {
          throw Exception('Đăng nhập thất bại: ${respData['message']}');
        }
        throw Exception('Đăng nhập thất bại. Mã: ${e.response?.statusCode}');
      }

      print('Lỗi đăng nhập: $e');
      throw Exception('Không thể kết nối đến server đăng nhập: ${e.message}');
    }
  }
}

// Khởi tạo instance API dùng chung
var testApi = Api();