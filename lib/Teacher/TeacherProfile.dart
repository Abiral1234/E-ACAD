import 'dart:convert';

import 'package:eacademia/Admin/Profile/UserPreferences.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart'as http;
import '../Colors.dart';
import 'Profile/ProfileWidget.dart';
import 'package:eacademia/Connection/conn.dart';
class TeacherProfile extends StatefulWidget {
  const TeacherProfile({Key? key}) : super(key: key);

  @override
  State<TeacherProfile> createState() => _TeacherProfileState();
}

class _TeacherProfileState extends State<TeacherProfile> {

  @override
  // ignore: must_call_super
  void initState() {
    getToken();

  }
  String refresh_token='';
  String access_token='';
  String email='';

  getToken() async{
    final SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    setState(() {
      refresh_token = sharedPreferences.get('refresh_token').toString();
      access_token = sharedPreferences.get('access_token').toString();
      email=sharedPreferences.get('email').toString();
    });
    getTeacherInformation();
  }

  String teacherId ='';
  String fullName ='';
  String contact ='';
  getTeacherInformation()async{
    try{
      var response = await http.get(
        Uri.parse("http://$host:8000/auth/teacher/"),
        headers: {
          'Authorization': 'Bearer $access_token',
        },
      );
      var data = jsonDecode(response.body.toString());
      for(int i =0; i<data.length;i++){
        if(data[i]["user"]["email"] == email){
          setState(() {
            teacherId = data[i]['id'].toString();
            fullName = data[i]['full_name'].toString();
            contact =data[i]['contact'].toString();
          });
        }
      }
      print(response.statusCode);
      // getBatchSubject();
    }
    catch(e){
      print(e);
    }
  }
  @override
  Widget build(BuildContext context) {
    final user = UserPreferences.myUser;
    return Container(
      color: lightBlue.withOpacity(0.2),
      child: Column(
        children: [
          SizedBox(height: 30,),
          ProfileWidget(
            imagePath : user.imagePath,
            onClicked:()async{},
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(0,10,0,0),
            child: Text(fullName,style: TextStyle(fontSize: 25,fontWeight: FontWeight.w500),),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(0,10,0,10),
            child: Text(email,style: TextStyle(fontSize: 16,fontWeight: FontWeight.w300,color: grey2),),
          ),
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              color: Colors.amber.withOpacity(0.1),
            ),
            padding: EdgeInsets.all(8),
            child: Padding(
              padding: const EdgeInsets.fromLTRB(4,0,4,0),
              child: Text("Teacher Level",style: TextStyle(fontSize: 20,fontWeight: FontWeight.w500),),
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
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [


                  Padding(
                    padding: const EdgeInsets.fromLTRB(15,10,0,15),
                    child: Text("About",style: TextStyle(fontSize: 25,fontWeight: FontWeight.w500),textAlign: TextAlign.left,),
                  ),
                  ListTile(
                    onTap: (){},
                    title:Text("Full name: $fullName"),
                  ),
                  ListTile(
                    onTap: (){},
                    title:Text("Email: $email"),
                  ),
                  ListTile(
                    onTap: (){},
                    title:Text("Contact No : $contact"),
                  ),
                  SizedBox(
                    height: 20,
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
