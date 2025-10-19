import 'package:flutter/material.dart';
import 'Views/Rootscreen.dart';
void main()=>runApp(MyApp());
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Rootscreen(), // chạy màn hình Login khi khởi động app
    );
  }
}