import 'package:flutter/material.dart';
import 'package:telekilogram/HomePage.dart';
class Welcomepage extends StatelessWidget {
  const Welcomepage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const AppNavigationDrawer(),
      body: SafeArea(
        child: mybody(context),
      ),
    );

  }

  Widget mybody(BuildContext context) { // Nhận context làm tham số
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header: Icons
            Row(
  mainAxisAlignment: MainAxisAlignment.spaceBetween,
  children: [
    Builder(
      builder: (context) => IconButton(
        icon: const Icon(Icons.menu),
        onPressed: () {
          Scaffold.of(context).openDrawer();
        },
      ),
    ),
    Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        IconButton(
          icon: const Icon(Icons.notifications),
          onPressed: () {},
        ),
        IconButton(
          icon: const Icon(Icons.extension),
          onPressed: () {},
        ),
      ],
    ),
  ],
),
            const SizedBox(height: 20),
            
            // Welcome Text
            const Text(
              "Welcome,",
              style: TextStyle(
                fontSize: 45,
                fontWeight: FontWeight.bold,
              ),
            ),
            const Text(
              "Charlie",
              style: TextStyle(
                fontSize: 45,
                fontWeight: FontWeight.normal,
              ),
            ),
            const SizedBox(height: 24),
            
            // Search Bar
            TextField(
              decoration: InputDecoration(
                hintText: "Search",
                prefixIcon: const Icon(Icons.search),
                filled: true,
                fillColor: Colors.grey[200],
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12.0),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
            const SizedBox(height: 24),
            
            // Section Title
            const Text(
              "Saved Places",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            
            // Grid Images
            GridView.count(
              crossAxisCount: 2,
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              children: [
                // Đảm bảo tên file khớp chính xác với trong thư mục assets/images/
                _buildGridItem('Untitled2.jpg'),
                _buildGridItem('Untitled3.jpg'),
                _buildGridItem('Untitled4.jpg'),
                _buildGridItem('Untitled1.jpg'),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildGridItem(String imagePath) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12.0),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 5,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      clipBehavior: Clip.antiAlias, // Cắt ảnh theo bo góc của Container
      child: Image.asset(
        imagePath,
        fit: BoxFit.cover,
        // SỬA: Thêm errorBuilder để xử lý khi không tìm thấy ảnh
        errorBuilder: (context, error, stackTrace) {
          return Container(
            color: Colors.grey[300],
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: const [
                Icon(Icons.broken_image, color: Colors.grey, size: 40),
                SizedBox(height: 4),
                Text(
                  "Lỗi ảnh",
                  style: TextStyle(color: Colors.grey, fontSize: 12),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}