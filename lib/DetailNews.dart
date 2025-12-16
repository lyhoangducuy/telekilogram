import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:telekilogram/models/News.dart';

class NewsDetailPage extends StatelessWidget {
  final NewsItem news;

  const NewsDetailPage({super.key, required this.news});

  void _openLink(BuildContext context, String url) async {
    final uri = Uri.parse(url);
    try {
      if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
        throw Exception("Không thể mở trình duyệt");
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Lỗi mở link: $e")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          // AppBar co giãn với ảnh nền
          SliverAppBar(
            expandedHeight: 300.0,
            floating: false,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              background: news.thumbnail.isNotEmpty
                  ? Image.network(
                      news.thumbnail,
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) => Container(color: Colors.grey, child: const Icon(Icons.broken_image)),
                    )
                  : Container(color: Colors.grey),
            ),
          ),
          
          // Nội dung bài viết
          SliverToBoxAdapter(
            child: Container(
              padding: const EdgeInsets.all(20),
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(30),
                  topRight: Radius.circular(30),
                ),
              ),
              // Dịch chuyển container lên trên một chút để đè lên ảnh tạo hiệu ứng layer
              transform: Matrix4.translationValues(0.0, -20.0, 0.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Thanh gạch ngang nhỏ trang trí
                  Center(
                    child: Container(
                      width: 40,
                      height: 4,
                      margin: const EdgeInsets.only(bottom: 20),
                      decoration: BoxDecoration(
                        color: Colors.grey[300],
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                  ),

                  Text(
                    news.title,
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.w800,
                      color: Colors.black87,
                      height: 1.3,
                    ),
                  ),
                  const SizedBox(height: 16),
                  //cors hình lỗi hiể thị ảnh mặc định
                  // Giả lập ngày đăng hoặc tác giả (vì API demo không parse trường này, ta để demo UI)
                  Row(
                    children: [
                      const Icon(Icons.access_time, size: 16, color: Colors.grey),
                      const SizedBox(width: 4),
                      Text("Vừa cập nhật", style: TextStyle(color: Colors.grey[600])),
                      const Spacer(),
                      const Icon(Icons.share, size: 20, color: Colors.blueAccent),
                    ],
                  ),
                  
                  const Divider(height: 40),

                  Text(
                    news.content.isEmpty ? news.shortDesc : news.content, // Fallback nếu content rỗng
                    style: const TextStyle(
                      fontSize: 16,
                      height: 1.6,
                      color: Colors.black87,
                    ),
                  ),

                  const SizedBox(height: 40),

                  // Nút bấm lớn
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton.icon(
                      onPressed: () => _openLink(context, news.url),
                      icon: const Icon(Icons.open_in_browser),
                      label: const Text("Đọc toàn bộ bài viết"),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blueAccent,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}