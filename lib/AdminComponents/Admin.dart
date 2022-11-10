import 'package:eacademia/Admin/AdminCallerList.dart';
import 'package:eacademia/Admin/AdminNotificationList.dart';
import 'package:eacademia/AdminComponents/EacademiaAppBar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../Admin/AdminHome.dart';
import '../Admin/AdminMessages.dart';
import '../Admin/AdminProfile.dart';
import '../Admin/AdminSendRequestToDeveloper.dart';
import '../Admin/AdminSetting.dart';
import '../Colors.dart';
import '../Fonts.dart';

class Admin extends StatefulWidget {
  const Admin({Key? key}) : super(key: key);

  @override
  State<Admin> createState() => _AdminState();
}

class _AdminState extends State<Admin>with TickerProviderStateMixin {

  @override
  // ignore: must_call_super
  void initState() {
    getToken();
  }
  String refresh_token='';
  String access_token='';

  getToken() async{
    final SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    setState(() {
      refresh_token = sharedPreferences.get('refresh_token').toString();
      access_token = sharedPreferences.get('access_token').toString();
    });

  }

  int currentIndex=0;
  final screens = [
    AdminHome(),
    AdminMessages(),
    AdminSendRequestToDeveloper(),
    AdminSetting(),
    AdminProfile(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backwardsCompatibility: false,
        title: Text('E-ACADEMIA',style: bigFontStyle, ),
        backgroundColor: blue,
        elevation: 0,
        excludeHeaderSemantics: true,
        foregroundColor: Colors.white,
        actions: [
          IconButton(icon: Icon(Icons.add_ic_call_sharp),
            onPressed: (){Get.to(AdminCallerList());},
          ),
           Padding(
            padding: EdgeInsets.fromLTRB(0,0,20,0),
            child: IconButton(icon: Icon(Icons.notifications),
              onPressed: (){Get.to(AdminNotificationList());},),
          ),
        ],
      ),
      body: screens[currentIndex],
      bottomNavigationBar: BottomNavigationBar(
          onTap: (index){
            setState(() {
              currentIndex = index;
            });
          },
          // onTap: (index)=> setState(() => currentIndex = index ),
          type: BottomNavigationBarType.fixed,
          currentIndex: currentIndex ,
          selectedItemColor: Colors.black,
          unselectedItemColor: grey1,
          items:  [
            BottomNavigationBarItem(
              icon: Icon(Icons.home_rounded) ,
              label: 'Home' ,
              backgroundColor: Colors.white,
            ),


            BottomNavigationBarItem(
              icon: Icon(Icons.messenger) ,
              label: 'Message' ,
              backgroundColor: Colors.blue,
            ),

            BottomNavigationBarItem(

              icon: Icon(Icons.add_circle_outlined,color: Colors.blue,size: 35,),
              label: '',

            ) ,

            BottomNavigationBarItem(
              icon: Icon(Icons.settings) ,
              label: 'Settings' ,
              backgroundColor: Colors.blue,
            ),

            BottomNavigationBarItem(
              icon: Icon(Icons.account_circle) ,
              label: 'Profile',
              backgroundColor: Colors.red,
            ),


          ]) ,
    );

  }
}
