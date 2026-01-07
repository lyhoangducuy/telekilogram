import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:telekilogram/auth/api_auth.dart';
import 'package:telekilogram/auth/auth_storage.dart';
import 'package:telekilogram/HomePage.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final _userCtrl = TextEditingController(text: "emilys");
  final _passCtrl = TextEditingController(text: "emilyspass");

  bool _obscure = true;
  bool _loading = false;

  @override
  void dispose() {
    _userCtrl.dispose();
    _passCtrl.dispose();
    super.dispose();
  }

  Future<void> _login() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _loading = true);
    try {
      final username = _userCtrl.text.trim();
      final password = _passCtrl.text;

      final data = await apiAuth.login(username, password);

      final access = (data["accessToken"] ?? "").toString(); // :contentReference[oaicite:6]{index=6}
      final refresh = (data["refreshToken"] ?? "").toString(); // :contentReference[oaicite:7]{index=7}
      if (access.isEmpty || refresh.isEmpty) {
        throw Exception("Không nhận đủ token từ API");
      }

      // Có thể lưu luôn user từ login response (vì login trả user fields)
      await AuthStorage.saveSession(
        accessToken: access,
        refreshToken: refresh,
        userJson: jsonEncode(data),
      );

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Đăng nhập OK ✅")),
      );

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const HomePage()),
      );
    } on DioException catch (e) {
      final msg = e.response?.data is Map
          ? (e.response?.data["message"]?.toString() ?? "Sai tài khoản/mật khẩu")
          : "Sai tài khoản/mật khẩu";
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Login fail ❌ $msg")));
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Có lỗi ❌ ${e.toString().replaceFirst("Exception: ", "")}")),
      );
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 420),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const Text(
                    "Telekilogram Shop",
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 26, fontWeight: FontWeight.w800),
                  ),
                  const SizedBox(height: 6),
                  const Text("Đăng nhập bằng DummyJSON", textAlign: TextAlign.center),
                  const SizedBox(height: 24),

                  Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        TextFormField(
                          controller: _userCtrl,
                          decoration: const InputDecoration(
                            labelText: "Username",
                            border: OutlineInputBorder(),
                          ),
                          validator: (v) => (v == null || v.trim().isEmpty) ? "Nhập username" : null,
                        ),
                        const SizedBox(height: 12),
                        TextFormField(
                          controller: _passCtrl,
                          obscureText: _obscure,
                          decoration: InputDecoration(
                            labelText: "Password",
                            border: const OutlineInputBorder(),
                            suffixIcon: IconButton(
                              onPressed: () => setState(() => _obscure = !_obscure),
                              icon: Icon(_obscure ? Icons.visibility : Icons.visibility_off),
                            ),
                          ),
                          validator: (v) => (v == null || v.isEmpty) ? "Nhập mật khẩu" : null,
                        ),
                        const SizedBox(height: 14),

                        SizedBox(
                          height: 46,
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: _loading ? null : _login,
                            child: _loading
                                ? const SizedBox(
                                    width: 18,
                                    height: 18,
                                    child: CircularProgressIndicator(strokeWidth: 2),
                                  )
                                : const Text("Đăng nhập"),
                          ),
                        ),

                        const SizedBox(height: 12),
                        const Text(
                          "Test: emilys / emilyspass",
                          style: TextStyle(fontSize: 12, color: Colors.grey),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
