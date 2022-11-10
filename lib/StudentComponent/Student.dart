import 'package:eacademia/AdminComponents/EacademiaAppBar.dart';
import 'package:eacademia/Student/StudentManageBook.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../Admin/AdminHome.dart';
import '../Admin/AdminMessages.dart';
import '../Admin/AdminProfile.dart';
import '../Admin/AdminSendRequestToDeveloper.dart';
import '../Admin/AdminSetting.dart';
import '../Colors.dart';
import '../Fonts.dart';
import '../Student/StudentCallerList.dart';
import '../Student/StudentDownloadNotes.dart';
import '../Student/StudentHome.dart';
import '../Student/StudentNotificationList.dart';
import '../Student/StudentProfile.dart';
import '../Student/StudentSettings.dart';

class Student extends StatefulWidget {
  const Student({Key? key}) : super(key: key);

  @override
  State<Student> createState() => _StudentState();
}

class _StudentState extends State<Student>with TickerProviderStateMixin {
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
    StudentHome(),
    StudentManageBook(),
    StudentDownloadNotes(),
    StudentSettings(),
    StudentProfile(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('E-ACADEMIA',style: GoogleFonts.bebasNeue(
          fontSize: 30
        ) , ),
        backgroundColor: blue,
        elevation: 0,
        excludeHeaderSemantics: true,
        foregroundColor: Colors.white,
        actions: [
          IconButton(icon: Icon(Icons.add_ic_call_sharp),
            onPressed: (){Get.to(StudentCallerList());},
          ),
          Padding(
            padding: EdgeInsets.fromLTRB(0,0,20,0),
            child: IconButton(icon: Icon(Icons.notifications),
              onPressed: (){Get.to(StudentNotificationList());},),
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
              icon: FaIcon(FontAwesomeIcons.home,size: 20,) ,
              label: 'Home' ,
              backgroundColor: Colors.white,
            ),


            BottomNavigationBarItem(
              icon: FaIcon(FontAwesomeIcons.book,size: 20,) ,
              label: 'Books' ,
              backgroundColor: Colors.blue,
            ),

            BottomNavigationBarItem(

              icon: FaIcon(FontAwesomeIcons.circleChevronDown,size: 25,color: blue,) ,
              label: '' ,

            ) ,

            BottomNavigationBarItem(
              icon: Icon(Icons.settings,size: 20,) ,
              label: 'Settings' ,
              backgroundColor: Colors.blue,
            ),

            BottomNavigationBarItem(
              icon: Icon(Icons.account_circle,size: 20,) ,
              label: 'Profile',
              backgroundColor: Colors.red,
            ),


          ]) ,
    );

  }
}
