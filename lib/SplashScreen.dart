import 'package:eacademia/Fonts.dart';
import 'package:eacademia/StudentComponent/Student.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'AdminComponents/Admin.dart';
import 'Colors.dart';
import 'LogIn/LogIn.dart';
import 'Teacher/Teacher.dart';
import 'package:eacademia/Connection/conn.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}
String RefreshToken='';
String AccessToken='';
String UserRole = '';
String UserId = '';

class _SplashScreenState extends State<SplashScreen> {

  @override
  void initState() {
    super.initState();
    _navigateToSplashScreen();
  }

  _navigateToSplashScreen() async{
    getValidationData().whenComplete(() async{
      await Future.delayed(const Duration( milliseconds : 5000) ,() {} );
      print("The user is");
      print(UserRole);
      if(UserRole == "superuser"){
        Get.offAll(Admin());
      }
      if(UserRole == "teacher"){
        Get.offAll(Teacher());
      }
      if(UserRole == "student"){
        Get.offAll(Student());
      }
      if(UserRole.toString() == "null"){
        Get.offAll(LogIn());
      }



      // print('The final Email is' +finalEmail);
      //  finalEmail =='null' ? Get.to(OnBoarding()) : Get.to(HomeAppBar3());
    });
  }
  Future getValidationData() async{
    final SharedPreferences sharedPreferences =await SharedPreferences.getInstance();
    String refreshToken = sharedPreferences.get('refresh_token').toString();
    String accessToken = sharedPreferences.get('access_token').toString();
    String userRole = sharedPreferences.get('user_role').toString();
    String userId = sharedPreferences.get('user_id').toString();
    setState(() {
      RefreshToken = refreshToken;
      AccessToken = accessToken;
      UserRole = userRole;
      UserId = userId;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: blue,
      body: Column(
        children: [

          Expanded(
            child: Center(
              child:
                  ClipOval(
                    child: Image.asset('assets/logo2.jpg',
                height: 200,
                width: 200,
              ),
                  ),

            ),
          ),

          Padding(
            padding: const EdgeInsets.fromLTRB(0,0,0,40.0),
            child: Text ("Version 1.1",
              style: GoogleFonts.manrope(
                textStyle: fontStyle,
                color: Colors.white,
              ),
            ),
          )
        ],
      ),
    );
  }
}
