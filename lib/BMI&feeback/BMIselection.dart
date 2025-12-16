import 'package:flutter/material.dart';

// Import các trang con (theo tên file trong ảnh của bạn)
// Lưu ý: Nếu báo lỗi class, hãy mở file đó ra xem tên class là gì
import 'my_BIMcaculator.dart';   
import 'my_Feedpack_Page.dart';  
import 'package:telekilogram/HomePage.dart';
class BmiFeedbackSelectionPage extends StatelessWidget {
  const BmiFeedbackSelectionPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      
    drawer: AppNavigationDrawer(),
      appBar: AppBar(
        title: const Text("BMI & Phản hồi"),
        backgroundColor: Colors.teal,
        foregroundColor: Colors.white,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Nút chọn BMI
            _buildOptionButton(
              context,
              title: "Tính BMI",
              icon: Icons.monitor_weight,
              color: Colors.teal,
              // Giả định tên class là BmiCalculatorPage (như code cũ)
              // Nếu lỗi, hãy sửa thành tên class trong file my_BIMcaculator.dart
              page: const BmiCalculatorPage(), 
            ),
            const SizedBox(height: 30),
            
            // Nút chọn Feedback
            _buildOptionButton(
              context,
              title: "Gửi Phản hồi",
              icon: Icons.feedback,
              color: Colors.deepOrange,
              // Giả định tên class là FeedbackPage (như code cũ)
              // Nếu lỗi, hãy sửa thành tên class trong file my_Feedpack_Page.dart
              page: const FeedbackPage(), 
            ),
          ],
        ),
      ),
    );
  }

  // Hàm tạo nút bấm lớn (tái sử dụng logic giống trang counter)
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