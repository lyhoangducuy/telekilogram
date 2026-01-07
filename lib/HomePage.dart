import 'package:flutter/material.dart';
import 'package:telekilogram/auth/auth_bootstrap_page.dart';
import 'package:telekilogram/auth/auth_storage.dart';
import 'package:telekilogram/auth/api_auth.dart';
import 'package:telekilogram/screens/profile/user_profile_page.dart';

import 'package:telekilogram/screens/product/products_page.dart';
import 'package:telekilogram/screens/cart/cart_page.dart';
import 'package:telekilogram/screens/hoaDon/orders_page.dart';
import 'package:telekilogram/controller/cart/cart_controller.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool _loadingMe = true;
  Map<String, dynamic>? _me; // user data from /auth/me

  @override
  void initState() {
    super.initState();
    _loadMe();
  }

  Future<void> _loadMe() async {
    try {
      final user = await apiAuth.meWithAutoRefresh();
      if (!mounted) return;
      setState(() {
        _me = user;
        _loadingMe = false;
      });
    } catch (_) {
      // Token lỗi/expired -> coi như logout
      await AuthStorage.clear();
      if (!mounted) return;
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (_) => const AuthBootstrapPage()),
        (_) => false,
      );
    }
  }

  Future<void> _logout() async {
    await AuthStorage.clear();
    if (!mounted) return;

    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (_) => const AuthBootstrapPage()),
      (_) => false,
    );
  }

  void _go(Widget page) {
    Navigator.push(context, MaterialPageRoute(builder: (_) => page));
  }

  String _fullName(Map<String, dynamic>? u) {
    final fn = (u?["firstName"] ?? "").toString().trim();
    final ln = (u?["lastName"] ?? "").toString().trim();
    final name = "$fn $ln".trim();
    return name.isEmpty ? "Telekilogram User" : name;
    // DummyJSON /auth/me có firstName, lastName, email, image
  }

  String _email(Map<String, dynamic>? u) {
    final e = (u?["email"] ?? "").toString().trim();
    return e.isEmpty ? "Đăng nhập bằng DummyJSON" : e;
  }

  String _avatarUrl(Map<String, dynamic>? u) {
    final img = (u?["image"] ?? "").toString().trim();
    return img.isEmpty ? "https://picsum.photos/200" : img;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Trang chủ - Sản phẩm"),
        backgroundColor: Colors.blue.shade700,
        centerTitle: true,
        actions: [
          // icon giỏ hàng + badge
          AnimatedBuilder(
            animation: cart,
            builder: (_, __) => IconButton(
              onPressed: () => _go(const CartPage()),
              icon: Stack(
                children: [
                  const Icon(Icons.shopping_cart),
                  if (cart.totalQty > 0)
                    Positioned(
                      right: 0,
                      top: 0,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 6,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.red,
                          borderRadius: BorderRadius.circular(999),
                        ),
                        child: Text(
                          "${cart.totalQty}",
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ),
        ],
      ),

      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            UserAccountsDrawerHeader(
              decoration: BoxDecoration(color: Colors.blue.shade700),
              accountName: Text(_loadingMe ? "Đang tải..." : _fullName(_me)),
              accountEmail: Text(_loadingMe ? "..." : _email(_me)),
              currentAccountPicture: CircleAvatar(
                backgroundImage: NetworkImage(_avatarUrl(_me)),
                onBackgroundImageError: (_, __) {},
                child: _loadingMe
                    ? const CircularProgressIndicator(strokeWidth: 2)
                    : null,
              ),
            ),

            ListTile(
              leading: const Icon(Icons.storefront),
              title: const Text("Sản phẩm"),
              onTap: () => Navigator.pop(context),
            ),

            ListTile(
              leading: const Icon(Icons.shopping_cart_checkout),
              title: const Text("Giỏ hàng"),
              onTap: () {
                Navigator.pop(context);
                _go(const CartPage());
              },
            ),

            ListTile(
              leading: const Icon(Icons.history),
              title: const Text("Đơn hàng / Lịch sử mua"),
              onTap: () {
                Navigator.pop(context);
                _go(const OrdersPage());
              },
            ),

           ListTile(
  leading: const Icon(Icons.person),
  title: const Text("Hồ sơ của tôi"),
  onTap: () {
    Navigator.pop(context);
    _go(const UserProfilePage());
  },
),


            ListTile(
              leading: const Icon(Icons.logout),
              title: const Text("Đăng xuất"),
              onTap: () {
                Navigator.pop(context);
                _logout();
              },
            ),
          ],
        ),
      ),

      body: const ProductsPage(),
    );
  }
}
