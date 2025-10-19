import 'package:flutter/material.dart';
import 'package:telekilogram/Models/UserLogin.dart';

enum FormStyle {login, register}

class LoginScreen extends StatefulWidget {
  final VoidCallback onSignedIn;
  LoginScreen({required this.onSignedIn});
  @override
  State<LoginScreen> createState() => LoginScreenState();
}
class LoginScreenState extends State<LoginScreen> {
  static final formKey = GlobalKey<FormState>();

  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  String authmin = '';
  FormStyle s = FormStyle.login;
  final Userlogin _user = Userlogin(username: "", password: "");
  String title = 'Đăng nhập';
  String error = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
      ),
      body: Container(
        padding: const EdgeInsets.all(10),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            xuatForm(),
            const SizedBox(height: 10),
            Nut(FormStyle.login),
            const SizedBox(height: 10),
            Nut(FormStyle.register),
            if (error.isNotEmpty)
              Text(error, style: const TextStyle(color: Colors.red)),
          ],
        ),
      ),
    );
  }

  Widget xuatForm() => s == FormStyle.login ? formDangNhap() : formDangKy();

  void bam(FormStyle t) {
    setState(() {
      if (t == FormStyle.login) {
        // ✅ Lấy dữ liệu từ TextField
        _user.username = _usernameController.text.trim();
        _user.password = _passwordController.text.trim();

        if (_user.username == "abc" && _user.password == "123456") {
          widget.onSignedIn();
          error = '';
        } else {
          error = 'Sai tên đăng nhập hoặc mật khẩu';
        }
      } else {
        title = 'Đăng ký';
        s = FormStyle.register;
        error = '';
      }
    });
  }

  Widget Nut(FormStyle nut) {
    return ElevatedButton.icon(
      onPressed: () => bam(nut),
      icon: const Icon(Icons.login),
      label: Text(
        nut == FormStyle.login ? 'Đăng nhập' : 'Đăng ký',
        style: const TextStyle(fontSize: 20),
      ),
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(vertical: 15),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        elevation: 5,
      ),
    );
  }

  Widget formDangNhap() {
    return Form(
      key: formKey,
      child: Column(
        children: [
          TextFormField(
            controller: _usernameController,
            decoration: const InputDecoration(labelText: 'UserName'),
          ),
          TextFormField(
            controller: _passwordController,
            decoration: const InputDecoration(labelText: 'Password'),
            obscureText: true,
          ),
        ],
      ),
    );
  }

  Widget formDangKy() {
    return Form(
      child: Column(
        children: [
          TextFormField(decoration: const InputDecoration(labelText: 'UserName')),
          TextFormField(
            decoration: const InputDecoration(labelText: 'Password'),
            obscureText: true,
          ),
          TextFormField(
            decoration: const InputDecoration(labelText: 'Phone'),
            keyboardType: TextInputType.phone,
          ),
          TextFormField(decoration: const InputDecoration(labelText: 'Địa chỉ')),
        ],
      ),
    );
  }
}

