import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import '../Untils/const.dart';

class BottomNavbar extends StatefulWidget {
  @override
  State<BottomNavbar> createState() => BottomNavbarState();
}

class BottomNavbarState extends State<BottomNavbar> {
  int pageIndex = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: pages[pageIndex],
      bottomNavigationBar: CupertinoTabBar(
        currentIndex: pageIndex,
        onTap: (index) {
          setState(() {
            pageIndex = index;
          });
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.chat, size: 32),
            label: "Chat",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.group, size: 32),
            label: "Group",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.feed, size: 32),
            label: "Feeds",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.account_box, size: 32),
            label: "Profile",
          ),
        ],
      ),
    );
  }
}
