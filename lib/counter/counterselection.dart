import 'package:flutter/material.dart';

// Import 2 trang con (đảm bảo tên file đúng với project của bạn)
import 'mycounterpage.dart';    
import 'mycountdownpage.dart';  
import 'package:telekilogram/HomePage.dart';

class CounterSelectionPage extends StatelessWidget {
  const CounterSelectionPage({super.key});

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
              title: "Bộ đếm (Counter)",
              icon: Icons.timer,
              color: Colors.green,
              page: const CounterPage(), // Class từ mycounterpage.dart
            ),
            const SizedBox(height: 30),
            
            // Nút chọn Countdown
            _buildOptionButton(
              context,
              title: "Đếm ngược (Countdown)",
              icon: Icons.timer,
              color: Colors.orange,
              page: const CountDownPage(), // Class từ mycountdownpage.dart
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