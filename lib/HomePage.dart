import 'package:flutter/material.dart';
import 'package:telekilogram/Welcomepage.dart';

import 'package:telekilogram/counter/counterselection.dart';
import 'package:telekilogram/MyProduct.dart';
import 'package:telekilogram/login&register/sigininselection.dart';
import 'package:telekilogram/BMI&feeback/BMIselection.dart';
import 'package:telekilogram/mychangecolorapp.dart';
import 'package:telekilogram/My_ClassRoom_page.dart';
import 'package:telekilogram/my_home_page.dart';
import 'package:telekilogram/login&register/my_Login_Page.dart';
import 'package:telekilogram/user_profile.dart';
class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      
      appBar: AppBar(
        title: const Text("Kiem tra giua ky"),
        backgroundColor: Colors.blue.shade700,
      ),
      drawer: const AppNavigationDrawer(),
      body: Center(child:Container( 
        padding: EdgeInsets.only(top: 24 + MediaQuery.of(context).padding.top, bottom: 24),
        child: Column(
        children: [
          CircleAvatar(
            radius: 52,
            backgroundImage: NetworkImage('https://picsum.photos/400/300'),
          ),
          Text(
            'Ly Hoang Duc Uy', style: TextStyle(fontSize: 28,color: Colors.purple.shade700),
          ),
          Text(
            '22t1020508@husc.edu.vn',style: TextStyle(fontSize: 28,color: Colors.purple.shade700),
          )
        ],
      ),
      ) ) 
    );
  }
}
class AppNavigationDrawer extends StatelessWidget {
  const AppNavigationDrawer({super.key});

  @override
  Widget build(BuildContext context) => Drawer(
    child: SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          buildHeader(context),
          buildMenuItems(context)
        ],
      ),
    ),
  );
  Widget buildHeader(BuildContext context)=>Container(
        padding: EdgeInsets.only(
          top:MediaQuery.of(context).padding.top
        ),
  );
  Widget buildMenuItems(BuildContext context)=>Container(
    padding: const EdgeInsets.all(24),
    child:Wrap(
      runSpacing: 16,
      children: [
        ListTile(
          leading: const Icon(Icons.home_outlined),
          title: const Text('Home'),
          onTap: ()=>Navigator.of(context).pushReplacement(MaterialPageRoute
              (builder: (context)=>const HomePage())),
        ),
        ListTile(
          leading: const Icon(Icons.bookmark),
          title: const Text('WelCome'),
          onTap: (){
            Navigator.of(context).push(MaterialPageRoute(builder: (context)=>const Welcomepage()));
          },
        ),
        ListTile(
          leading: const Icon(Icons.bookmark),
          title: const Text('Dem nguoc va dem so'),
          onTap: (){
            Navigator.of(context).push(MaterialPageRoute(builder: (context)=>const CounterSelectionPage()));
          },
        ),ListTile(
          leading: const Icon(Icons.bookmark),
          title: const Text('Dang nhap va dang xuat'),
          onTap: (){
            Navigator.of(context).push(MaterialPageRoute(builder: (context)=>const Sigininselection()));
          },
        ),ListTile(
          leading: const Icon(Icons.bookmark),
          title: const Text('BMI & Feed back'),
          onTap: (){
            Navigator.of(context).push(MaterialPageRoute(builder: (context)=>const BmiFeedbackSelectionPage()));
          },
        ),ListTile(
          leading: const Icon(Icons.bookmark),
          title: const Text('Danh sach san pham  va chi tiet san pham'),
          onTap: (){
            Navigator.of(context).push(MaterialPageRoute(builder: (context)=>const MyProduct()));
          },
        ),ListTile(
          leading: const Icon(Icons.bookmark),
          title: const Text('Doi mau'),
          onTap: (){
            Navigator.of(context).push(MaterialPageRoute(builder: (context)=>const Mychangecorapp()));
          },
        ),ListTile(
          leading: const Icon(Icons.bookmark),
          title: const Text('Bao'),
          onTap: (){
            Navigator.of(context).push(MaterialPageRoute(builder: (context)=>const MyHomePage()));
          },
        ),
        ListTile(
          leading: const Icon(Icons.bookmark),
          title: const Text('Classroom'),
          onTap: (){
            Navigator.of(context).push(MaterialPageRoute(builder: (context)=>const homeclassroom()));
          },
        ),
        ListTile(
          leading: const Icon(Icons.bookmark),
          title: const Text('Dang nhap token'),
          onTap: (){
            Navigator.of(context).push(MaterialPageRoute(builder: (context)=>const LoginPage()));
          },
        )
      ],
    )
  );
}
