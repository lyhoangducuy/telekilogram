import 'package:flutter/material.dart';
import 'package:telekilogram/HomePage.dart';
class MyHomePage extends StatelessWidget {
  const MyHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      
      drawer: AppNavigationDrawer(),
      appBar: AppBar(
        title: const Text("Classrom"),
        backgroundColor: Colors.blue.shade700,
      ),
      body: Column(
        children: [
          block1(),
          block2(),
          block3(),
          block4(),
        ],
      ),
    );
  }
  Widget block1(){
    var src = "https://media.istockphoto.com/id/517188688/vi/anh/phong-c%E1%BA%A3nh-n%C3%BAi-non.jpg?s=612x612&w=0&k=20&c=WWWaejSo6EWGZMZSK7QK6LCfwd0rL2KB3ImCX2VkW4A=";
    return Image.network(src);
  }
  Widget block2(){
    return Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                children: [
                  Text("Oeschinen Lake Campground"),
                  Text("Kandersteg, Switzerland"),
                ],
              ),
              Row(
                children: [
                  Icon(Icons.star, color: Colors.red,),
                  Text("41"),
                ],
              ),
            ],
            );
  }
  Widget block3(){
    return Row(
       
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Column(
                children: [
                  Icon(Icons.call, color: Colors.blue,),
                  Text("CALL", style: TextStyle(color: Colors.blue),)
                ],
              ),
              Column(
                children: [
                  Icon(Icons.near_me, color: Colors.blue,),
                  Text("ROUTE", style: TextStyle(color: Colors.blue),)
                ],
              ),
              Column(
                children: [
                  Icon(Icons.share, color: Colors.blue,),
                  Text("SHARE", style: TextStyle(color: Colors.blue),)
                ],
              ),
            ],

          );
  }
  Widget block4(){
   return Text("Lake Oeschinen lies at the foot of the Blüemlisalp in the Bernese Alps. Situated 1,578 meters above sea level, it is one of the larger Alpine Lakes. A gondola ride from Kandersteg, followed by a half-hour walk through pastures and pine forest, leads you to the lake, which warms to 20 degrees Celsius in the summer. Activities enjoyed here include rowing, and riding the summer toboggan run.");
  }
}
