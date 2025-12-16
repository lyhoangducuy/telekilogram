import 'package:flutter/material.dart';
import 'package:telekilogram/models/product.dart';

class ProductDetails extends StatelessWidget {
  final Product product;
  const ProductDetails({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    // Ép kiểu giá an toàn hơn
    final price = product.price is num
        ? (product.price as num).toStringAsFixed(2)
        : product.price.toString();
    
    // Màu chủ đạo
    const Color primaryColor = Color(0xFFE53935); // Màu đỏ tươi

    return Scaffold(
      backgroundColor: Colors.white,
      
      // --- APP BAR ---
      appBar: AppBar(
        title: Text(
          'Chi tiết Sản phẩm',
          style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.black87),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        foregroundColor: Colors.black87,
      ),
      
      // --- BODY ---
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            
            // 1. KHU VỰC ẢNH SẢN PHẨM (Nổi bật)
            Hero( // Thêm Hero animation cho chuyển cảnh mượt mà
              tag: 'product-${product.id}', 
              child: AspectRatio(
                aspectRatio: 1.0, // Ảnh vuông
                child: Image.network(
                  product.image,
                  fit: BoxFit.contain, // Dùng contain để ảnh không bị cắt
                  width: double.infinity,
                  errorBuilder: (context, error, stackTrace) => Container(
                    color: Colors.grey[200],
                    child: const Center(child: Icon(Icons.broken_image, size: 60, color: Colors.grey)),
                  ),
                ),
              ),
            ),
            
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  
                  // 2. GIÁ VÀ RATING
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // GIÁ
                      Text(
                        "${price} VNĐ",
                        style: const TextStyle(
                            fontSize: 28, 
                            color: primaryColor, 
                            fontWeight: FontWeight.w900),
                      ),
                      
                      // RATING
                      Row(
                        children: [
                          const Icon(Icons.star, color: Colors.amber, size: 20),
                          const SizedBox(width: 6),
                          Text(
                            product.rating.rate.toStringAsFixed(1),
                            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(width: 4),
                          Text(
                            '(${product.rating.count})', 
                            style: const TextStyle(color: Colors.black54, fontSize: 16)),
                        ],
                      ),
                    ],
                  ),
                  
                  const Divider(height: 30),
                  
                  // 3. TÊN SẢN PHẨM
                  Text(
                    product.title,
                    style: const TextStyle(fontSize: 24, fontWeight: FontWeight.w700),
                  ),

                  const SizedBox(height: 12),
                  
                  // 4. CATEGORY (Chip)
                  Chip(
                    label: Text(product.category.toUpperCase()),
                    backgroundColor: primaryColor.withOpacity(0.1),
                    labelStyle: const TextStyle(color: primaryColor, fontWeight: FontWeight.w600),
                  ),

                  const SizedBox(height: 20),
                  
                  // 5. MÔ TẢ
                  const Text('Mô tả Chi tiết', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700)),
                  const SizedBox(height: 8),
                  Text(
                    product.description,
                    style: const TextStyle(fontSize: 15, height: 1.5),
                  ),
                  const SizedBox(height: 80), // Thêm khoảng trống để nội dung không bị che bởi BottomBar
                ],
              ),
            ),
          ],
        ),
      ),
      
      // --- BOTTOM NAVIGATION BAR (Nút cố định) ---
      bottomNavigationBar: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 10,
              offset: const Offset(0, -5),
            ),
          ],
        ),
        child: SizedBox(
          height: 50,
          child: ElevatedButton.icon(
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Đã thêm ${product.title} vào giỏ hàng!')),
              );
            },
            icon: const Icon(Icons.add_shopping_cart, size: 24),
            label: const Text('Thêm vào giỏ hàng', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            style: ElevatedButton.styleFrom(
              backgroundColor: primaryColor,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          ),
        ),
      ),
    );
  }
}