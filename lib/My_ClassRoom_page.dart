import 'dart:math';
import 'package:flutter/material.dart';
import 'package:telekilogram/HomePage.dart';
// Class name giữ nguyên theo code bạn gửi
class homeclassroom extends StatelessWidget {
  const homeclassroom({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: AppNavigationDrawer(),
      appBar: AppBar(
        title: const Text("Lớp học"),
        backgroundColor: Colors.blue[900],
        foregroundColor: Colors.white,
      ),
      body: SafeArea(child: mybody()),
    );
  }

  Widget mybody() {
    return ListView(
      scrollDirection: Axis.vertical,
      children: List.generate(20, (index) => item()),
    );
  }

  Widget item() {
    return Container(
      padding: const EdgeInsets.all(10),
      margin: const EdgeInsets.only(top: 10, left: 10, right: 10, bottom: 0),
      height: 140, // Đặt chiều cao cố định để ảnh hiển thị đẹp hơn
      decoration: BoxDecoration(
        border: Border.all(color: Colors.black),
        borderRadius: BorderRadius.circular(10),
        image: const DecorationImage(
          image: NetworkImage('https://picsum.photos/seed/picsum/400/200'), 
          fit: BoxFit.cover,
        ),
      ),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: Colors.black.withOpacity(0.5), // Tăng độ tối để chữ dễ đọc hơn
        ),
        padding: const EdgeInsets.all(10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  Text(
                    "Lập trình ứng dụng cho các thiết bị di động - Nhóm 4",
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 18, // Tăng font size
                        fontWeight: FontWeight.bold),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(height: 8),
                  Text(
                    "2025-2026.1.TIN4403.004",
                    style: TextStyle(color: Colors.white70, fontSize: 14),
                  ),
                  SizedBox(height: 12),
                  Text(
                    "50 students",
                    style: TextStyle(color: Colors.white, fontWeight: FontWeight.w500),
                  ),
                ],
              ),
            ),
            const Icon(Icons.more_horiz, color: Colors.white),
          ],
        ),
      ),
    );
  }
}