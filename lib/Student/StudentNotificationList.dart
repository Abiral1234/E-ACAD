import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../Colors.dart';
import '../Connection/conn.dart';
import '../Fonts.dart';
import '../Services/noti.dart';
import 'StudentCallerList.dart';
import 'package:http/http.dart' as http;

// final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

class StudentNotificationList extends StatefulWidget {
  const StudentNotificationList({Key? key}) : super(key: key);

  @override
  State<StudentNotificationList> createState() => _StudentNotificationListState();
}

class _StudentNotificationListState extends State<StudentNotificationList> {
  @override
  // ignore: must_call_super
  void initState() {
    // Noti.initialize(flutterLocalNotificationsPlugin);
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
      email = sharedPreferences.get('email').toString();

    });
    getStudentInformation();
  }
  bool loading =false;
  bool success = false;
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
      getAllNotification();
      print(response.statusCode);
    }
    catch (e) {
      print(e);
    }
  }
  var events =[];
  var fees =[];
  var notication=[];
  String grade = '';
  getAllNotification() async{
    final SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    int? prev_notification_length = sharedPreferences.getInt('notification_length');

    print("Checkpoint");
    var response;
    setState(() {
      loading = true;
    });
    try {
      setState(() {
        loading = true;
      });
      response = await http.get(
          Uri.parse("http://$host:8000/class/"),
          headers: {
            'Authorization': 'Bearer $access_token',
          }
      );

      var data = jsonDecode(response.body.toString());
      print(data);
      print("Checkpoint");
      for(int i=0;i<data.length;i++){
        if(data[i]['faculty']+"_"+data[i]['year'].toString() == batchName ){
          setState(() {
            grade = data[i]['id'].toString();
          });

        }
      }
      print("The grade Id is");
      print(grade);
      print("Checkpoint");
      var response2 = await http.get(
          Uri.parse("http://$host:8000/event_notifications/"),
          headers: {
            'Authorization': 'Bearer $access_token',
          }
      );

      var data2 = jsonDecode(response2.body.toString());
      print(data2);
      print("Checkpoint");
      for(int i=0;i<data2.length;i++){
       if(data2[i]['grade'].toString() == grade){
         setState(() {
           notication.add(data2[i]);
         });

       }
      }
      print("Checkpoint");
      var response3 = await http.get(
          Uri.parse("http://$host:8000/fee_notifications/"),
          headers: {
            'Authorization': 'Bearer $access_token',
          }
      );
      print("Checkpoint");
      var data3 = jsonDecode(response3.body.toString());
      print(data3);

      for(int i=0;i<data3.length;i++){
        if(data3[i]['grade'].toString() == grade){
          setState(() {
            notication.add(data3[i]);
          });

        }
      }
      print("notifaiction length is");
      print(notication.length);
      for(int? i = prev_notification_length  ; i!<notication.length;i++){
        // Noti.showBigTextNotification(
        //     title: "Notification Alert",
        //     body: notication[i]['message'],
        //     fln: flutterLocalNotificationsPlugin
        // );

      }
      final SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
      sharedPreferences.setInt('notification_length', notication.length);

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
            itemCount: notication.length,
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
                            Text("To: $batchName",
                              style: GoogleFonts.manrope(
                                  fontWeight: FontWeight.bold),),
                            SizedBox(height: 8,),
                            Text(notication[notication.length - index-1]["message"],
                              style: GoogleFonts.manrope(
                                  color: grey1, fontSize: 14),),
                            SizedBox(height: 8,),
                            Text("3 days ago"),
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
