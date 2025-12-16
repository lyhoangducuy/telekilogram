import 'package:flutter/material.dart';
import './api.dart';
import 'package:telekilogram/models/product.dart';
import './product_details.dart';
import 'package:telekilogram/HomePage.dart';
import 'package:telekilogram/cart_store.dart';
class MyProduct extends StatefulWidget {
  const MyProduct({super.key});

  @override
  State<MyProduct> createState() => _MyProductState();
}

class _MyProductState extends State<MyProduct> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const AppNavigationDrawer(),
      appBar: AppBar(
        title: const Text(
          'Danh sách sản phẩm',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.cyan,
        actions: [
          IconButton(
            icon: const Icon(Icons.shopping_cart),
            onPressed: () {
              _showCart(context);
            },
          )
        ],
      ),
      body: FutureBuilder<List<Product>>(
        future: testApi.getAllProducts(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Lỗi: ${snapshot.error}'));
          }
          final products = snapshot.data!;
          return myListView(products);
        },
      ),
    );
  }

  Widget myListView(List<Product> ls) {
    final width = MediaQuery.of(context).size.width;
    final crossAxisCount = width > 900 ? 4 : (width > 600 ? 3 : 2);

    return GridView.builder(
      padding: const EdgeInsets.all(12),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: crossAxisCount,
        mainAxisSpacing: 12,
        crossAxisSpacing: 12,
        childAspectRatio: 0.55,
      ),
      itemCount: ls.length,
      itemBuilder: (context, index) => myItem(ls[index]),
    );
  }

Widget myItem(Product p) {
  return InkWell(
    onTap: () {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => ProductDetails(product: p),
        ),
      );
    },
    child: Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      elevation: 3,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AspectRatio(
            aspectRatio: 1,
            child: Hero(
              tag: 'product-${p.id}', // QUAN TRỌNG
              child: Image.network(
                p.image,
                fit: BoxFit.contain,
                errorBuilder: (_, __, ___) =>
                    const Icon(Icons.image_not_supported),
              ),
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(8),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    p.title,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  Text(
                    '\$${p.price}',
                    style: const TextStyle(
                      color: Colors.red,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      icon: const Icon(Icons.add_shopping_cart, size: 16),
                      label: const Text(
                        'Thêm vào giỏ',
                        style: TextStyle(fontSize: 12),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.cyan,
                        foregroundColor: Colors.white,
                      ),
                      onPressed: () {
                        CartStore.add(p);
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('Đã thêm "${p.title}" vào giỏ'),
                            duration: const Duration(seconds: 1),
                          ),
                        );
                      },
                    ),
                  )
                ],
              ),
            ),
          )
        ],
      ),
    ),
  );
}


  void _showCart(BuildContext context) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    builder: (_) => StatefulBuilder(
      builder: (context, setState) {
        return Container(
          padding: const EdgeInsets.all(16),
          height: 400,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Giỏ hàng',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const Divider(),

              /// DANH SÁCH SẢN PHẨM
              Expanded(
                child: CartStore.items.isEmpty
                    ? const Center(child: Text('Giỏ hàng trống'))
                    : ListView.builder(
                        itemCount: CartStore.items.length,
                        itemBuilder: (context, index) {
                          final item = CartStore.items[index];
                          return ListTile(
                            title: Text(item.title),
                            trailing: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  '\$${item.price}',
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                IconButton(
                                  icon: const Icon(Icons.delete, color: Colors.red),
                                  onPressed: () {
                                    setState(() {
                                      CartStore.remove(item);
                                    });
                                  },
                                ),
                              ],
                            ),
                          );
                        },
                      ),
              ),

              const Divider(),

              /// TỔNG TIỀN
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Tổng tiền:',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    '\$${CartStore.totalPrice.toStringAsFixed(2)}',
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.red,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 12),

              /// NÚT XÓA TẤT CẢ
              Row(
  children: [
    Expanded(
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.red,
        ),
        onPressed: () {
          setState(() {
            CartStore.clear();
          });
        },
        child: const Text('Xóa giỏ'),
      ),
    ),
    const SizedBox(width: 12),
    Expanded(
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.green,
        ),
        onPressed: CartStore.items.isEmpty
            ? null
            : () {
                _fakeCheckout(context, setState);
              },
        child: const Text('Thanh toán'),
      ),
    ),
  ],
),

            ],
          ),
        );
      },
    ),
  );
}

}
void _fakeCheckout(BuildContext context, StateSetter setState) {
  showDialog(
    context: context,
    builder: (_) => AlertDialog(
      title: const Text('Xác nhận thanh toán'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Tổng tiền cần thanh toán:'),
          const SizedBox(height: 8),
          Text(
            '\$${CartStore.totalPrice.toStringAsFixed(2)}',
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.red,
            ),
          ),
        ],
      ),
      actions: [
        TextButton(
          child: const Text('Hủy'),
          onPressed: () => Navigator.pop(context),
        ),
        ElevatedButton(
          style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
          child: const Text('Xác nhận'),
          onPressed: () {
            setState(() {
              CartStore.clear();
            });
            Navigator.pop(context); // đóng dialog
            Navigator.pop(context); // đóng bottom sheet

            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('✅ Thanh toán thành công!'),
                duration: Duration(seconds: 2),
              ),
            );
          },
        ),
      ],
    ),
  );
}
