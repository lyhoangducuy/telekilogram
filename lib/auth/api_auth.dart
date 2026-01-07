import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:telekilogram/auth/auth_storage.dart';

class ApiAuth {
  final Dio _dio = Dio(
    BaseOptions(
      baseUrl: "https://dummyjson.com",
      connectTimeout: const Duration(seconds: 15),
      receiveTimeout: const Duration(seconds: 15),
      headers: {"Content-Type": "application/json"},
    ),
  );

  /// POST /auth/login -> trả accessToken + refreshToken + user fields
  Future<Map<String, dynamic>> login(String username, String password) async {
    final res = await _dio.post(
      "/auth/login",
      data: {
        "username": username,
        "password": password,
        "expiresInMins": 60, // optional :contentReference[oaicite:3]{index=3}
      },
    );

    if (res.data is Map) return Map<String, dynamic>.from(res.data);
    throw Exception("Response không hợp lệ");
  }

  /// GET /auth/me -> cần Bearer accessToken :contentReference[oaicite:4]{index=4}
  Future<Map<String, dynamic>> me(String accessToken) async {
    final res = await _dio.get(
      "/auth/me",
      options: Options(headers: {"Authorization": "Bearer $accessToken"}),
    );
    if (res.data is Map) return Map<String, dynamic>.from(res.data);
    throw Exception("Response /auth/me không hợp lệ");
  }

  /// POST /auth/refresh -> refresh token :contentReference[oaicite:5]{index=5}
  Future<Map<String, dynamic>> refresh(String refreshToken) async {
    final res = await _dio.post(
      "/auth/refresh",
      data: {"refreshToken": refreshToken, "expiresInMins": 60},
    );
    if (res.data is Map) return Map<String, dynamic>.from(res.data);
    throw Exception("Response /auth/refresh không hợp lệ");
  }

  /// Gói tiện: nếu accessToken hết hạn -> refresh -> gọi lại me
  Future<Map<String, dynamic>> meWithAutoRefresh() async {
    final access = await AuthStorage.accessToken();
    final refreshT = await AuthStorage.refreshToken();
    if (access == null || refreshT == null) throw Exception("Chưa đăng nhập");

    try {
      return await me(access);
    } on DioException catch (e) {
      // Nếu token expired/401 -> refresh thử
      final code = e.response?.statusCode;
      if (code == 401 || code == 403) {
        final newTokens = await refresh(refreshT);
        final newAccess = (newTokens["accessToken"] ?? "").toString();
        final newRefresh = (newTokens["refreshToken"] ?? refreshT).toString();
        if (newAccess.isEmpty) rethrow;

        final user = await me(newAccess);
        await AuthStorage.saveSession(
          accessToken: newAccess,
          refreshToken: newRefresh,
          userJson: jsonEncode(user),
        );
        return user;
      }
      rethrow;
    }
  }
  Future<Map<String, dynamic>> updateUser({
  required int id,
  required String accessToken,
  String? phone,
  Map<String, dynamic>? address, // { address: "...", city: "...", ... }
}) async {
  final res = await _dio.patch(
    "/users/$id",
    data: {
      if (phone != null) "phone": phone,
      if (address != null) "address": address,
    },
    options: Options(headers: {"Authorization": "Bearer $accessToken"}),
  );

  if (res.data is Map) return Map<String, dynamic>.from(res.data);
  throw Exception("Update user thất bại");
}

}

final apiAuth = ApiAuth();
