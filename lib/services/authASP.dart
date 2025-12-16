import '../models/user.dart';
import '../models/user_response.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../untils/const.dart';
import 'dart:convert';

class AuthASP {
  AuthASP();

  Future<UserResponse> signIn(String username, String password) async {
    UserResponse resp = UserResponse();

    final Map<String, String> param = {
      'username': username,
      'password': password,
    };

    try {
      final url = Uri.parse('$baseURL/api/Users/authenticate');

      final response = await http.post(
        url,
        headers: const {
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(param),
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> json =
            jsonDecode(response.body);

        // ✅ Parse user
        final user = User.fromJson(json);
        resp.user = user;
        resp.error = '200';

        // ✅ LẤY TOKEN
        final accessToken = json['accessToken'];
        final refreshToken = json['refreshToken'];

        // ✅ LƯU TOKEN
        final prefs = await SharedPreferences.getInstance();
        if (accessToken != null) {
          await prefs.setString('accessToken', accessToken);
        }
        if (refreshToken != null) {
          await prefs.setString('refreshToken', refreshToken);
        }
      } else {
        resp.error =
            '${response.statusCode} ${response.body}';
      }
    } catch (e) {
      resp.error = e.toString();
    }

    return resp;
  }

  /// ✅ LOGOUT
  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
  }

  /// ✅ GET TOKEN
  Future<String?> getAccessToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('accessToken');
  }
}
