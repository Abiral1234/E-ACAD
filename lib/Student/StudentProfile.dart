import 'dart:convert';

import 'package:eacademia/Admin/Profile/UserPreferences.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../Colors.dart';
import '../Connection/conn.dart';
import 'Profile/ProfileWidget.dart';
import 'package:http/http.dart' as http;

class StudentProfile extends StatefulWidget {
  const StudentProfile({Key? key}) : super(key: key);

  @override
  State<StudentProfile> createState() => _StudentProfileState();
}

class _StudentProfileState extends State<StudentProfile> {
  @override
  // ignore: must_call_super
  void initState() {
    getToken();
  }

  String refresh_token = '';
  String access_token = '';
  String userId = "";
  String email = '';
  bool loading = false;

  getToken() async {
    final SharedPreferences sharedPreferences = await SharedPreferences
        .getInstance();
    setState(() {
      refresh_token = sharedPreferences.get('refresh_token').toString();
      access_token = sharedPreferences.get('access_token').toString();
      userId = sharedPreferences.get('user_id').toString();
      email = sharedPreferences.get('email').toString();
    });
    print("The User ID is");
    print(userId);
    print("The email is");
    print(email);
    getStudentInformation();
  }

  String studentId = '';
  String fullName = '';
  String regNumber = '';
  String batchName = '';
  String contact = '';
  String dob = '';

  getStudentInformation() async {
    try {
      var response = await http.get(
        Uri.parse("http://$host:8000/auth/student/"),
        headers: {
          'Authorization': 'Bearer $access_token',
        },
      );
      var data = jsonDecode(response.body.toString());
      for (int i = 0; i < data.length; i++) {
        if (data[i]["user"]["email"] == email) {
          setState(() {
            studentId = data[i]['id'].toString();
            fullName = data[i]['full_name'].toString();
            regNumber = data[i]['registration_number'].toString();
            batchName = data[i]['batch_name'].toString();
            contact = data[i]['contact'].toString();
            dob = data[i]['dob'].toString();
          });
        }
      }
      print(response.statusCode);
    }
    catch (e) {
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
            imagePath: 'assets/student.png',
            onClicked: () async {},
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(0, 10, 0, 0),
            child: Text(fullName,
              style: TextStyle(fontSize: 25, fontWeight: FontWeight.w500),),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
            child: Text(email, style: TextStyle(
                fontSize: 16, fontWeight: FontWeight.w300, color: grey2),),
          ),
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              color: Colors.deepPurpleAccent.withOpacity(0.1),
            ),
            padding: EdgeInsets.all(8),
            child: Padding(
              padding: const EdgeInsets.fromLTRB(4, 0, 4, 0),
              child: Text("Student Level",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500),),
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
                    padding: const EdgeInsets.fromLTRB(15, 10, 0, 15),
                    child: Text("About", style: TextStyle(
                        fontSize: 25, fontWeight: FontWeight.w500),
                      textAlign: TextAlign.left,),
                  ),
                  // fullName = '';
                  // String regNumber = '';
                  // String batchName = '';
                  // String contact = '';
                  // String dob = '';
                  ListTile(
                    leading: Text("Full name:"),
                    title: Text("$fullName"),
                  ),
                  ListTile(
                    leading: Text("Registration Number:"),
                    title: Text("$regNumber"),
                  ),
                  ListTile(
                    leading: Text("Batch Name: "),
                    title: Text("$batchName"),
                  ),
                  ListTile(
                    leading: Text("Contact Number:"),
                    title: Text("$contact"),
                  ),
                  ListTile(
                    leading: Text("Date of birth:"),
                    title: Text("$dob"),
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
