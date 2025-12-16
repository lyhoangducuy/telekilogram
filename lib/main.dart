import 'package:flutter/material.dart';
import 'package:telekilogram/HomePage.dart';

void main(){
  runApp(MyApp());
}
class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      //home:Time(),
      //home:Number(),
      home:HomePage(),
    );
  }
}