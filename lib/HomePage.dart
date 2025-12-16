import 'package:flutter/material.dart';
import 'package:telekilogram/Welcomepage.dart';
import 'package:telekilogram/counter/counterselection.dart';
import 'package:telekilogram/login&register/sigininselection.dart';
import 'package:telekilogram/BMI&feeback/BMIselection.dart';
import 'package:telekilogram/mychangecolorapp.dart';
import 'package:telekilogram/My_ClassRoom_page.dart';
import 'package:telekilogram/my_home_page.dart';
import 'package:telekilogram/login&register/my_Login_Page.dart';
import 'package:telekilogram/MyProduct.dart';
import 'package:telekilogram/ListPage.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Trang chủ"),
        backgroundColor: Colors.blue.shade700,
        centerTitle: true,
      ),
      drawer: const AppNavigationDrawer(),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // ===== HEADER =====
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.blue.shade50,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Row(
                children: [
                  const CircleAvatar(
                    radius: 40,
                    backgroundImage: NetworkImage('https://picsum.photos/400'),
                  ),
                  const SizedBox(width: 16),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const [
                      Text(
                        "Ly Hoang Duc Uy",
                        style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(height: 4),
                      Text(
                        "22t1020508@husc.edu.vn",
                        style: TextStyle(color: Colors.grey),
                      ),
                    ],
                  )
                ],
              ),
            ),

            const SizedBox(height: 24),

            // ===== GRID MENU =====
            GridView.count(
              crossAxisCount: 2,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              mainAxisSpacing: 16,
              crossAxisSpacing: 16,
              children: [
                HomeMenuItem(
                  icon: Icons.newspaper,
                  title: "News",
                  color: Colors.orange,
                  onTap: () => _go(context, const NewsListPage()),
                ),
                HomeMenuItem(
                  icon: Icons.calculate,
                  title: "Counter",
                  color: Colors.green,
                  onTap: () => _go(context, const CounterSelectionPage()),
                ),
                HomeMenuItem(
                  icon: Icons.fitness_center,
                  title: "BMI",
                  color: Colors.purple,
                  onTap: () => _go(context, const BmiFeedbackSelectionPage()),
                ),
                HomeMenuItem(
                  icon: Icons.shopping_bag,
                  title: "Sản phẩm",
                  color: Colors.blue,
                  onTap: () => _go(context, const MyProduct()),
                ),
                HomeMenuItem(
                  icon: Icons.color_lens,
                  title: "Đổi màu",
                  color: Colors.red,
                  onTap: () => _go(context, const Mychangecorapp()),
                ),
                HomeMenuItem(
                  icon: Icons.school,
                  title: "Classroom",
                  color: Colors.teal,
                  onTap: () => _go(context, const homeclassroom()),
                ),
                HomeMenuItem(
                  icon: Icons.login,
                  title: "Đăng nhập",
                  color: Colors.indigo,
                  onTap: () => _go(context, const LoginPage()),
                ),
                HomeMenuItem(
                  icon: Icons.info,
                  title: "Welcome",
                  color: Colors.brown,
                  onTap: () => _go(context, const Welcomepage()),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _go(BuildContext context, Widget page) {
    Navigator.push(context, MaterialPageRoute(builder: (_) => page));
  }
}
class HomeMenuItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final Color color;
  final VoidCallback onTap;

  const HomeMenuItem({
    super.key,
    required this.icon,
    required this.title,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircleAvatar(
              radius: 28,
              backgroundColor: color,
              child: Icon(icon, color: Colors.white, size: 28),
            ),
            const SizedBox(height: 12),
            Text(
              title,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
            )
          ],
        ),
      ),
    );
  }
}


class AppNavigationDrawer extends StatelessWidget {
  const AppNavigationDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: [
          _buildHeader(),
          Expanded(child: _buildMenu(context)),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return UserAccountsDrawerHeader(
      decoration: BoxDecoration(color: Colors.blue.shade700),
      accountName: const Text(
        "Lý Hoàng Đức Uy",
        style: TextStyle(fontWeight: FontWeight.bold),
      ),
      accountEmail: const Text("22t1020508@husc.edu.vn"),
      currentAccountPicture: const CircleAvatar(
        backgroundImage: NetworkImage('https://picsum.photos/200'),
      ),
    );
  }

  Widget _buildMenu(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.symmetric(vertical: 8),
      children: [
        _drawerItem(context, Icons.home_outlined, "Home", const HomePage()),
        _drawerItem(context, Icons.waving_hand, "Welcome", const Welcomepage()),
        _drawerItem(context, Icons.timer, "Đếm số / Đếm ngược", const CounterSelectionPage()),
        _drawerItem(context, Icons.login, "Đăng nhập / Đăng xuất", const Sigininselection()),
        _drawerItem(context, Icons.monitor_weight, "BMI & Feedback", const BmiFeedbackSelectionPage()),
        _drawerItem(context, Icons.shopping_bag, "Sản phẩm", const MyProduct()),
        _drawerItem(context, Icons.color_lens, "Đổi màu", const Mychangecorapp()),
        _drawerItem(context, Icons.article, "Báo", const MyHomePage()),
        _drawerItem(context, Icons.school, "Classroom", const homeclassroom()),
        _drawerItem(context, Icons.key, "Đăng nhập Token", const LoginPage()),
        _drawerItem(context, Icons.newspaper, "News", const NewsListPage()),
      ],
    );
  }

  Widget _drawerItem(
    BuildContext context,
    IconData icon,
    String title,
    Widget page,
  ) {
    return ListTile(
      leading: Icon(icon, color: Colors.blue.shade700),
      title: Text(title),
      onTap: () {
        Navigator.pop(context);
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => page),
        );
      },
    );
  }
}
