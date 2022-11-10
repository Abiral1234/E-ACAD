import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../Colors.dart';
import 'package:http/http.dart' as http;
import 'package:eacademia/Connection/conn.dart';

class PrivacyAndSecurity extends StatefulWidget {
  const PrivacyAndSecurity({Key? key}) : super(key: key);

  @override
  State<PrivacyAndSecurity> createState() => _PrivacyAndSecurityState();
}

class _PrivacyAndSecurityState extends State<PrivacyAndSecurity> {

  _goToNotificationList(){
    Navigator.of(context).pushNamed('/Show_Recent_Notification');
  }
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
  bool loading =false;
  bool success = false;
  List classes=[];
  getBatches() async{
    var response;
    setState(() {
      loading = true;
    });
    try {
      setState(() {
        loading = true;
      });
      print("The access token is");
      print(access_token);
      response = await http.get(
        Uri.parse("http://$host:8000/class/"),
        headers: {
          'Authorization': 'Bearer $access_token',
        },
      );
      print(response.body);
      print(response.statusCode);
      if(response.statusCode == 200){
        var data = jsonDecode(response.body.toString());
        classes=data;
        for(int i=0 ; i<classes.length;i++){
          String batchName = data[i]['faculty']+ "_" +data[i]['year'];
          batch_list.add(batchName);
        }

        setState(() {
          loading = false;
        });
      }

    }
    catch(e){
      print(e);
    }
  }

  createPrivacyAndSecurity() async {
    var response;
    setState(() {
      loading = true;
    });
    try {
      setState(() {
        loading = true;
      });
      print("The access Token is ");
      print(access_token);
      response = await http.post(
        Uri.parse("http://$host:8000/fee_notifications/"),
        headers: {
          'Authorization': 'Bearer $access_token',
        },
        body: {
          "batch_name": "BESE",
          "message": message.text,
        },
      );
      print(response.body);
      setState(() {
        loading = false;
        success = true;
      });
    }
    catch(e){

    }
  }
  TextEditingController batchname = TextEditingController();
  TextEditingController message = TextEditingController();
  var batch_list=[
    'Select a batch',
  ];
  String value = 'Select a batch';
  String eAcademia =
      "E-ACADEMIA is a College Management Application which will help to manage attendance, keep track of the library books, provide notifications about any events and many more. ";
      String admin = "College admin can add students and teacher account for the upcoming batches so this application is of future use as well. Admin will assign student in a classroom and also assign subjects for the teacher. ";
      String teacher = "A teacher can take students' attendance and display their overall attendance score, and percentage and display whether the individual student can give the exam or not.Teachers notify the students about any events or holidays happening in the college.";
      String student = "Students could check about their attendance information and get noticed about any kinds of events and track their book.";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('About E-Academia',style: TextStyle(fontFamily: 'Aerial',color: white),),
        backgroundColor:blue,
        elevation: 0,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15.0,vertical: 10 ),
            child: Text(eAcademia,
              style: TextStyle(
                fontSize: 18,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15.0,vertical: 10 ),
            child: Text(admin,
              style: TextStyle(
                fontSize: 18,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15.0,vertical: 10 ),
            child: Text(teacher,
              style: TextStyle(
                fontSize: 18,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15.0,vertical: 10 ),
            child: Text(student,
              style: TextStyle(
                fontSize: 18,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
DropdownMenuItem<String> buildMenuItem(String batch){
  return DropdownMenuItem(
      value: batch,
      child: Text(
        batch,
      ));

}