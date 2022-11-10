import 'dart:convert';

import 'package:eacademia/Admin/AddProfile.dart';
import 'package:eacademia/Admin/Profile/UserPreferences.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../Colors.dart';
import 'Profile/ProfileWidget.dart';
import 'package:http/http.dart' as http;
import 'package:eacademia/Connection/conn.dart';
class AdminProfile extends StatefulWidget {
  const AdminProfile({Key? key}) : super(key: key);

  @override
  State<AdminProfile> createState() => _AdminProfileState();
}

class _AdminProfileState extends State<AdminProfile> {


  @override
  // ignore: must_call_super
  void initState() {
    getToken();

  }
  String refresh_token='';
  String access_token='';
  String email = '';
  getToken() async{
    final SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    setState(() {
      refresh_token = sharedPreferences.get('refresh_token').toString();
      access_token = sharedPreferences.get('access_token').toString();
      email = sharedPreferences.get('email').toString();
    });
     getAboutAdmin();
  }
  bool loading =false;
  bool success = false;

  TextEditingController teacherMessage = new TextEditingController();
  getAboutAdmin() async{
    var response;
    setState(() {
      loading = true;
    });
    try {
      setState(() {
        loading = true;
      });
      response = await http.get(
          Uri.parse("http://$host:8000/about_admin/"),
          headers: {
            'Authorization': 'Bearer $access_token',
          }
      );
      print(response.body);
      var data = jsonDecode(response.body.toString());
      setState(() {
        int lastIndex =data.length-1;
        aboutAdmin.text = data[lastIndex]['about'];
      });

      // print(aboutAdmin);
      // print(aboutAdmin.length);
      // print(aboutAdmin[0]['about']);
      setState(() {
        loading = false;
        success = true;
      });
    }
    catch(e){
      print(e);
    }
  }
  TextEditingController aboutAdmin = new TextEditingController();

  @override
  Widget build(BuildContext context) {
    final user = UserPreferences.myUser;
    return Container(
      color: lightBlue.withOpacity(0.2),
      child: Column(
        children: [
          SizedBox(height: 30,),
          GestureDetector(
            onTap: (){ Get.to(AddProfile());},
            child: ProfileWidget(
              imagePath : 'assets/login/Admin.png',
              onClicked:()async{

              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(0,10,0,0),
            child: Text("Admin 1",style: TextStyle(fontSize: 25,fontWeight: FontWeight.w500),),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(0,10,0,10),
            child: Text(email,style: TextStyle(fontSize: 16,fontWeight: FontWeight.w300,color: grey2),),
          ),
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              color: Colors.red.withOpacity(0.1),
            ),
            padding: EdgeInsets.all(8),
            child: Padding(
              padding: const EdgeInsets.fromLTRB(4,0,4,0),
              child: Text("Admin Level",style: TextStyle(fontSize: 20,fontWeight: FontWeight.w500),),
            ),
          ),
          SizedBox(
            height: 20,
          ),
          Padding(
            padding: EdgeInsets.fromLTRB(20, 0, 20, 10),
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                color: Colors.blue.withOpacity(0.1),
              ),

              child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(15,10,0,15),
                    child: Text("About",style: TextStyle(fontSize: 25,fontWeight: FontWeight.w500),textAlign: TextAlign.left,),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(15,10,20,20),
                    child: Text(
                       aboutAdmin.text,
                      style: TextStyle(fontSize: 16),textAlign: TextAlign.start,),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
