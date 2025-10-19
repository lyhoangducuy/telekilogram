import 'package:flutter/material.dart';
import 'BottomNavbar.dart';
import 'LoginScreen.dart';

enum AuthStatus{notSigned, signed}
class Rootscreen extends StatefulWidget{
  
  @override
  State<StatefulWidget> createState(){
    return RootscreenState();
  }
  
} 
class RootscreenState extends State<Rootscreen>{
  AuthStatus authStatus= AuthStatus.notSigned;
   void _signedIn() {
    setState(() {
      authStatus = AuthStatus.signed; // 👈 đổi sang signed
    });
  }
  @override
  Widget build(BuildContext context)
  {
    switch(authStatus){
      case (AuthStatus.notSigned):
           return LoginScreen(onSignedIn: _signedIn);
      case (AuthStatus.signed):
        return BottomNavbar();
    }
    
  }
  
}
