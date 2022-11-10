import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../Colors.dart';
import '../../Connection/conn.dart';
import '../StudentHome.dart';
import 'package:http/http.dart' as http;

class StudentClassHome extends StatefulWidget {
  String studentId;
  String subjectId;
  String subjectName;
  StudentClassHome(this.studentId, this.subjectId,this.subjectName ,{Key? key}) : super(key: key);

  @override
  State<StudentClassHome> createState() => _StudentClassHomeState();
}

class _StudentClassHomeState extends State<StudentClassHome> {
  double presentDays =0;
  double totalDays=0;
  bool today = false;

  @override
  // ignore: must_call_super
  void initState() {
    getToken();

  }
  String refresh_token='';
  String access_token='';
  String user_id='';


  getToken() async{
    final SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    setState(() {
      refresh_token = sharedPreferences.get('refresh_token').toString();
      access_token = sharedPreferences.get('access_token').toString();
      user_id = sharedPreferences.get('user_id').toString();
    });
    getSubjectAttendance();
  }
  bool loading =false;
  bool success = false;
  var messages =[];
  TextEditingController teacherMessage = new TextEditingController();
  getSubjectAttendance()async{
    var response;
    try {
      setState(() {
        loading = true;
      });
      response = await http.get(
          Uri.parse("http://$host:8000/teacher/attendence/"),
          headers: {
            'Authorization': 'Bearer $access_token',
          }
      );
      var data = jsonDecode(response.body.toString());
      for(int i=0;i<data.length;i++){
        if(data[i]["student"]['id'].toString() == widget.studentId && data[i]["subject"]['id'].toString() == widget.subjectId){
          if(data[i]['status'] == "present"){
            setState(() {
              presentDays = presentDays+1;
              totalDays = totalDays+1;
            });
          }
          if(data[i]['status'] == "absent"){
            setState(() {
              totalDays = totalDays+1;
            });
          }
          List date = data[i]['attended_on'].split(" ");
          print(date[0]);
          String todayDate = DateFormat('yyyy-MM-dd').format(DateTime.now());
          print(todayDate);
          if(date[0] == todayDate){
            setState(() {
              today = true;
            });
          }
        }
      }
      setState(() {
        loading = false;
        success = true;
      });
    }
    catch(e){
      print(e);
    }
  }
  @override
  Widget build(BuildContext context) {
    double percentFraction = totalDays == 0 ? 0 :(presentDays/totalDays);
    return SingleChildScrollView(
      child: Column(
        children: [
          SizedBox(height: 40),
          SizedBox(height: 20),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Center(
                  child: CircularPercentIndicator(
                    radius: 120,
                    lineWidth: 10,
                    percent: percentFraction,
                    progressColor: percentFraction > 0.70 ? green :red,
                    backgroundColor: grey6,
                    circularStrokeCap: CircularStrokeCap.round,
                    center: Text((percentFraction*100).toInt().toString()+"%",style: TextStyle(fontSize: 20),),
                    animateFromLastPercent: true ,
                    animation: true,
                    animationDuration: 1000,
                  ),
                ),
                SizedBox(height: 15),
                Center(
                  child: Container(

                      child: Align(
                          alignment: Alignment.center,
                          child: Text(widget.subjectName,style: TextStyle(fontSize: 20,),textAlign: TextAlign.center,)
                      )),
                ),
                SizedBox(height: 15),
                Center(child: Text(presentDays.toInt().toString()+"/"+totalDays.toInt().toString(),style: TextStyle(fontSize: 25,fontWeight: FontWeight.w500),textAlign: TextAlign.center,)),
                SizedBox(height: 25),
                Card(
                  child:ListTile(
                    title: Text("Attendance Today"),
                    subtitle: Padding(
                      padding: const EdgeInsets.fromLTRB(0,0,0,10),
                      child: today ?Text("Present",style: TextStyle(fontSize: 25,color: Colors.black),):
                      Text("Absent",style: TextStyle(fontSize: 25,color: Colors.black),),
                    ),
                    trailing:today  ? FaIcon(FontAwesomeIcons.solidCircleCheck,color: green,size: 35,):
                    Icon(Icons.cancel,color: red, size: 40,),
                  )
                ),
                SizedBox(
                  height: 15,
                ),
                // Padding(
                //   padding: const EdgeInsets.symmetric(horizontal: 8.0),
                //   child: Text("Statistics",style: TextStyle(fontSize: 25,fontWeight: FontWeight.w500),),
                // ),
                // SizedBox(
                //   height: 15,
                // ),
                // Card(
                //   child: Padding(
                //     padding: const EdgeInsets.all(10.0),
                //     child: LinearPercentIndicator(
                //       leading: Padding(
                //         padding: const EdgeInsets.symmetric(horizontal: 10.0),
                //         child: Text("Class Average",style: TextStyle(fontSize: 16),),
                //       ),
                //       lineHeight: 35,
                //       percent: 0.4,
                //       progressColor: Colors.lightBlueAccent,
                //       backgroundColor: grey5,
                //       animation: true,
                //       linearStrokeCap: LinearStrokeCap.butt,
                //       center: Text((0.4*100).toInt().toString()+"%",style: TextStyle(fontSize: 20),),
                //     ),
                //   ),
                // ),
                // Card(
                //   child: Padding(
                //     padding: const EdgeInsets.all(10.0),
                //     child: LinearPercentIndicator(
                //       leading: Padding(
                //         padding: const EdgeInsets.symmetric(horizontal: 10.0),
                //         child: Text("Class Average",style: TextStyle(fontSize: 16),),
                //       ),
                //       lineHeight: 35,
                //       percent: 0.4,
                //       progressColor: Colors.lightBlueAccent,
                //       backgroundColor: grey5,
                //       animation: true,
                //       linearStrokeCap: LinearStrokeCap.butt,
                //       center: Text((0.4*100).toInt().toString()+"%",style: TextStyle(fontSize: 20),),
                //     ),
                //   ),
                // ),
                // Card(
                //   child: Padding(
                //     padding: const EdgeInsets.all(10.0),
                //     child: LinearPercentIndicator(
                //       leading: Padding(
                //         padding: const EdgeInsets.symmetric(horizontal: 10.0),
                //         child: Text("Class Average",style: TextStyle(fontSize: 16),),
                //       ),
                //       lineHeight: 35,
                //       percent: 0.4,
                //       progressColor: Colors.lightBlueAccent,
                //       backgroundColor: grey5,
                //       animation: true,
                //       linearStrokeCap: LinearStrokeCap.butt,
                //       center: Text((0.4*100).toInt().toString()+"%",style: TextStyle(fontSize: 20),),
                //     ),
                //   ),
                // ),
                // Card(
                //   child: Padding(
                //     padding: const EdgeInsets.all(10.0),
                //     child: LinearPercentIndicator(
                //       leading: Padding(
                //         padding: const EdgeInsets.symmetric(horizontal: 10.0),
                //         child: Text("Class Average",style: TextStyle(fontSize: 16),),
                //       ),
                //       lineHeight: 35,
                //       percent: 0.4,
                //       progressColor: Colors.lightBlueAccent,
                //       backgroundColor: grey5,
                //       animation: true,
                //       linearStrokeCap: LinearStrokeCap.butt,
                //       center: Text((0.4*100).toInt().toString()+"%",style: TextStyle(fontSize: 20),),
                //     ),
                //   ),
                // ),
                // Card(
                //   child: Padding(
                //     padding: const EdgeInsets.all(10.0),
                //     child: LinearPercentIndicator(
                //       leading: Padding(
                //         padding: const EdgeInsets.symmetric(horizontal: 10.0),
                //         child: Text("Class Average",style: TextStyle(fontSize: 16),),
                //       ),
                //       lineHeight: 35,
                //       percent: 0.4,
                //       progressColor: Colors.lightBlueAccent,
                //       backgroundColor: grey5,
                //       animation: true,
                //       linearStrokeCap: LinearStrokeCap.butt,
                //       center: Text((0.4*100).toInt().toString()+"%",style: TextStyle(fontSize: 20),),
                //     ),
                //   ),
                // ),
                // Card(
                //   child: Padding(
                //     padding: const EdgeInsets.all(10.0),
                //     child: LinearPercentIndicator(
                //       leading: Padding(
                //         padding: const EdgeInsets.symmetric(horizontal: 10.0),
                //         child: Text("Class Average",style: TextStyle(fontSize: 16),),
                //       ),
                //       lineHeight: 35,
                //       percent: 0.4,
                //       progressColor: Colors.lightBlueAccent,
                //       backgroundColor: grey5,
                //       animation: true,
                //       linearStrokeCap: LinearStrokeCap.butt,
                //       center: Text((0.4*100).toInt().toString()+"%",style: TextStyle(fontSize: 20),),
                //     ),
                //   ),
                // ),

              ],
            ),
          ),

        ],
      ),
    );
  }
}
