
import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:kotlin/UI/auth/login_screen.dart';
import 'package:kotlin/UI/inventory_management/select_machine_for_item.dart';
import 'package:kotlin/UI/widgets/main_screen.dart';



class SplashServices{
  void isLogin(BuildContext context){

    final auth = FirebaseAuth.instance;
    final user=auth.currentUser;

if(user!=null){                                                         //selectMachineForItems() for inventory
Timer(const Duration(seconds:3 ),                                            //fireStoreScreen() for machine management
()=>Navigator.push( context, MaterialPageRoute(builder: (context)=> ManagementScreen())));//PostScreen for admin

}else{
Timer(const Duration(seconds:3 ),
()=>Navigator.push( context, MaterialPageRoute(builder: (context)=>LoginScreen() )));

}

   }
}