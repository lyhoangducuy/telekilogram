import 'package:flutter/material.dart';
import 'package:telekilogram/auth/auth_storage.dart';
import 'package:telekilogram/HomePage.dart';
import 'package:telekilogram/auth/login_page.dart';

class AuthBootstrapPage extends StatefulWidget {
  const AuthBootstrapPage({super.key});

  @override
  State<AuthBootstrapPage> createState() => _AuthBootstrapPageState();
}

class _AuthBootstrapPageState extends State<AuthBootstrapPage> {
  @override
  void initState() {
    super.initState();
    _go();
  }

  Future<void> _go() async {
    final ok = await AuthStorage.isLoggedIn();
    if (!mounted) return;

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => ok ? const HomePage() : const LoginPage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(child: CircularProgressIndicator()),
    );
  }
}
