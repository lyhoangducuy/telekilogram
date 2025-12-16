import 'package:flutter/material.dart';

// Import 2 trang con (đảm bảo tên file đúng với project của bạn)
import 'my_login_Page.dart';    
import 'my_signup_page.dart'; 
import 'package:telekilogram/HomePage.dart';

class Sigininselection extends StatelessWidget {
  const Sigininselection({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      
      drawer: AppNavigationDrawer(),
      appBar: AppBar(
        title: const Text("Chọn Bộ đếm"),
        backgroundColor: Colors.indigo,
        foregroundColor: Colors.white,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Nút chọn Counter
            _buildOptionButton(
              context,
              title: "Đăng Nhập",
              icon: Icons.person,
              color: Colors.green,
              page: const LoginPage(), // Class từ mycounterpage.dart
            ),
            const SizedBox(height: 30),
            
            // Nút chọn Countdown
            _buildOptionButton(
              context,
              title: "Đăng Ký",
              icon: Icons.person_add,
              color: Colors.orange,
              page: const MySignupPage(), // Class từ mycountdownpage.dart
            ),
          ],
        ),
      ),
    );
  }

  // Hàm tạo nút bấm lớn
  Widget _buildOptionButton(BuildContext context,
      {required String title,
      required IconData icon,
      required Color color,
      required Widget page}) {
    return SizedBox(
      width: 280,
      height: 80,
      child: ElevatedButton.icon(
        style: ElevatedButton.styleFrom(
          backgroundColor: color,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          elevation: 5,
        ),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => page),
          );
        },
        icon: Icon(icon, size: 32),
        label: Text(
          title,
          style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}