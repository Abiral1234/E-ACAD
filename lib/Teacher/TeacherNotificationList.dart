import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../Colors.dart';
import '../Connection/conn.dart';
import '../Fonts.dart';
import 'package:http/http.dart' as http;

class TeacherNotificationList extends StatefulWidget {
  const  TeacherNotificationList({Key? key}) : super(key: key);

  @override
  State<TeacherNotificationList> createState() => _TeacherNotificationListState();
}

class _TeacherNotificationListState extends State<TeacherNotificationList > {
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
    getAdminFeedback();
  }
  bool loading =false;
  bool success = false;

  var feedback=[];
  getAdminFeedback() async{
    var response;
    setState(() {
      loading = true;
    });
    try {
      setState(() {
        loading = true;
      });
      response = await http.get(
          Uri.parse("http://$host:8000/get_feedback/"),
          headers: {
            'Authorization': 'Bearer $access_token',
          }
      );

      var data = jsonDecode(response.body.toString());
      print(data);
      setState(() {
        feedback=data;
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
    return  Scaffold(
      appBar: AppBar(
        backwardsCompatibility: false,
        title: Text('Notification',style: fontStyle, ),
        backgroundColor: blue,
        elevation: 0,
        excludeHeaderSemantics: true,
        foregroundColor: Colors.white,
      ),
      body:Padding(
        padding: const EdgeInsets.all(8.0),
        child: ListView.builder(
            itemCount: feedback.length,
            itemBuilder: (BuildContext context, int index) {
              return
                Column(
                  children: [
                    Card(
                      child: ListTile(
                        title: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(feedback[feedback.length -index-1]["subject"] ,
                              style: GoogleFonts.manrope(
                                  fontWeight: FontWeight.bold),),
                            SizedBox(height: 8,),
                            Text(feedback[feedback.length - index-1]["message"],
                              style: GoogleFonts.manrope(
                                  color: grey1, fontSize: 14),),
                            SizedBox(height: 8,),
                            // Text("3 days ago"),
                            SizedBox(height: 8,),
                          ],
                        ),
                        onTap: () {},

                      ),
                    ),
                    SizedBox(height: 5),
                  ],
                );
            }
        ),
      ),
    );
  }
}
