import 'package:flutter/material.dart';
import 'package:telekilogram/models/News.dart';
import 'package:telekilogram/DetailNews.dart';
import 'package:telekilogram/HomePage.dart';
class NewsListPage extends StatefulWidget {
  const NewsListPage({super.key});

  @override
  State<NewsListPage> createState() => _NewsListPageState();
}

class _NewsListPageState extends State<NewsListPage> {
  late Future<List<NewsItem>> futureNews;

  @override
  void initState() {
    super.initState();
    futureNews = NewsApi.fetchNews();
  }

  // Hàm refresh để kéo xuống tải lại trang
  Future<void> _refresh() async {
    setState(() {
      futureNews = NewsApi.fetchNews();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: AppNavigationDrawer(),
      backgroundColor: Colors.grey[100], // Màu nền xám nhẹ hiện đại
      appBar: AppBar(
        title: const Text(
          "Tin Tức",
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black87),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
      ),
      body: RefreshIndicator(
        onRefresh: _refresh,
        child: FutureBuilder<List<NewsItem>>(
          future: futureNews,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }
            if (snapshot.hasError) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.error_outline, size: 48, color: Colors.red),
                    const SizedBox(height: 10),
                    Text("Lỗi: ${snapshot.error}", textAlign: TextAlign.center),
                    ElevatedButton(onPressed: _refresh, child: const Text("Thử lại"))
                  ],
                ),
              );
            }

            final news = snapshot.data!;
            return ListView.separated(
              padding: const EdgeInsets.all(12),
              itemCount: news.length,
              separatorBuilder: (context, index) => const SizedBox(height: 12),
              itemBuilder: (context, index) {
                final item = news[index];
                return NewsCard(item: item);
              },
            );
          },
        ),
      ),
    );
  }
}

// Widget tách riêng để code gọn và dễ quản lý
class NewsCard extends StatelessWidget {
  final NewsItem item;

  const NewsCard({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      clipBehavior: Clip.antiAlias, // Để ảnh không bị tràn ra khỏi góc bo
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => NewsDetailPage(news: item)),
          );
        },
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Phần ảnh: Chiều cao cố định, full chiều rộng
            SizedBox(
              height: 180,
              width: double.infinity,
              child: item.thumbnail.isNotEmpty
                  ? Image.network(
                      item.thumbnail,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) =>
                          Container(color: Colors.grey[300], child: const Icon(Icons.broken_image, size: 50, color: Colors.grey)),
                      loadingBuilder: (context, child, loadingProgress) {
                        if (loadingProgress == null) return child;
                        return Container(color: Colors.grey[200], child: const Center(child: CircularProgressIndicator()));
                      },
                    )
                  : Container(color: Colors.grey[300], child: const Icon(Icons.image, size: 50, color: Colors.grey)),
            ),
            
            // Phần nội dung chữ
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item.title,
                    style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, height: 1.3),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    item.shortDesc,
                    style: TextStyle(fontSize: 14, color: Colors.grey[700], height: 1.4),
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}