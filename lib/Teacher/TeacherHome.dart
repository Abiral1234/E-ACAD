import 'dart:convert';
import 'dart:ui';
import 'package:eacademia/AdminComponents/Cards.dart';
import 'package:eacademia/AdminComponents/Admin.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../Colors.dart';
import '../Fonts.dart';
import 'package:http/http.dart' as http;
import 'package:eacademia/Connection/conn.dart';
final faculties=[
  '-- SELECT YOUR CLASS --',
  'BESE_2015 (AOS)',
  'BESE_2016 (DSA)',
  'BESE_2017 (ADA)',
  'BESE_2018 (EE)',

];

class TeacherHome extends StatefulWidget {
  String subjectId;
  String subject;
  String batch;
  TeacherHome({Key? key,required this.subjectId ,required this.subject,required this.batch}) : super(key: key);

  @override
  State<TeacherHome> createState() => _TeacherHomeState();
}

class _TeacherHomeState extends State<TeacherHome>with MaterialStateMixin {
  @override
  // ignore: must_call_super
  void initState() {
    print("The subject ID is");
    print(widget.subjectId);
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
    getStudents();
    getAttendance();
    getSubjects();
  }
  getAttendance()async{
    var response = await http.get(
        Uri.parse("http://$host:8000/teacher/attendence-list/"),
        headers: {
          'Authorization': 'Bearer $access_token',
        }
    );
    // print(response.body);
  }
  bool loading =false;
  bool success = false;
  var allStudents =[];
  var students =[];
  var AttendanceRecord={};
  getSubjects() async{
    var response;
    setState(() {
      loading = true;
    });
    try {
      setState(() {
        loading = true;
      });
      response = await http.get(
          Uri.parse("http://$host:8000/teacher/subject-list/"),
          headers: {
            'Authorization': 'Bearer $access_token',
          }
      );
      var data = jsonDecode(response.body.toString());
      print("The subject list are");
      print(data);

      setState(() {
        loading = false;
      });
    }
    catch(e){
        print(e);
    }
  }
  getStudents() async{
    var response;
    setState(() {
      loading = true;
    });
    try {
      setState(() {
        loading = true;
      });
      response = await http.get(
        Uri.parse("http://$host:8000/auth/student/"),
        headers: {
          'Authorization': 'Bearer $access_token',
        }
      );
      var data = jsonDecode(response.body.toString());
      allStudents = data;
      for(int i =0 ; i<allStudents.length;i++){
        if(allStudents[i]['batch_name'] == widget.batch){
          students.add(allStudents[i]);
        }
      }
      setState(() {
        loading = false;
      });
    }
    catch(e){
      print(e);
    }
  }
  String error = '';
  TakeAttendance() async {
    var response;
    setState(() {
      loading = true;
    });
    try {
      setState(() {
        loading = true;
      });
      print("The subject ID is");
      print(widget.subjectId);
      if(students.length==AttendanceRecord.length) {
        for(int i =0 ; i<students.length ;i++){
          var data = {
            "student": {
              "id":AttendanceRecord[i]['id'].toString(),
            },
            "subject": {
              "id":widget.subjectId,
              },
            "status": AttendanceRecord[i]['status'],
          };
          print(data);
          response = await http.post(
              Uri.parse("http://$host:8000/teacher/attendence/"),
              headers: {
                'content-type': 'application/json',
                'Authorization': 'Bearer $access_token',
              },
              body: jsonEncode(data)
          );
          print(response.body);
        }
        setState(() {
          loading = false;
          success = true;
          error='';
        });
      }
      else{
        error= "Please take attendance of all Students";
        setState(() {
          loading = false;
        });

      }
    }
    catch(e){
      print(e);
    }
  }
  // Color tileColor1=Colors.white;
  // Color tileColor2=Colors.white;
  // Color tileColor3=Colors.white;
  // Color tileColor4=Colors.white;
  // Color tileColor5=Colors.white;
  // Color tileColor6=Colors.white;
  markAllPresent(){
    for(int i =0 ;i<students.length ;i++){
      AttendanceRecord[i] ={
        "id" : "${students[i]['id']}",
        "name" : "${students[i]['full_name']}",
        "status" : "present",
      };
      setState(() {
        tileColor[i] = green.withOpacity(0.2);
      });

    }
    print(AttendanceRecord);

  }
  markAllAbsent(){
    for(int i =0 ;i<students.length ;i++){
      AttendanceRecord[i] ={
        "id" : "${students[i]['id']}",
        "name" : "${students[i]['full_name']}",
        "status" : "absent",
      };
      setState(() {
        tileColor[i] = red.withOpacity(0.2);
      });

    }
    print(AttendanceRecord);
  }
  markAllNeutral(){
    for(int i =0 ;i<students.length ;i++){
      setState(() {
        AttendanceRecord ={};
        tileColor[i] = Colors.white;
      });
    print(AttendanceRecord);
    }
  }

  var tileColor ={};
  String? value= faculties[0];
  @override
  Widget build(BuildContext context) {
    double height =MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return SingleChildScrollView(
      child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: Column(
            children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 20.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            color: blue,
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(10),
                              topRight: Radius.circular(10),
                            )
                          ),
                          width: width,
                          height: 50,
                          child: Row(
                           children: [
                             Padding(
                               padding: const EdgeInsets.symmetric(horizontal: 10.0),
                               child: Container(
                                   child: Text("SN",style: TextStyle(color: white),
                                   ),
                                 width: width*0.11,
                               ),
                             ),
                             Container(
                               child: Text("Student Name",style: TextStyle(color: white,fontSize: 14),
                               ),
                               width: width*0.32,
                             ),
                             Container(

                               child: Text("Status",style: TextStyle(color: white,fontSize: 14),
                               ),
                               width: width*0.16,
                             ),
                             GestureDetector(
                               onTap: (){
                                 setState(() {
                                   markAllPresent();
                                 });
                               },
                               child: Padding(
                                 padding: const EdgeInsets.symmetric(horizontal: 8),
                                 child: Icon(Icons.check_circle,color: white,),
                               ),
                             ),
                             GestureDetector(
                               onTap: (){
                                 setState(() {
                                   markAllAbsent();
                                 });
                               }
                               ,
                               child: Padding(
                                 padding: const EdgeInsets.symmetric(horizontal: 8),
                                 child: Icon(Icons.close,color: white,),
                               ),
                             ),
                             GestureDetector(
                               onTap: (){
                                 setState(() {
                                   markAllNeutral();
                                 });
                               },
                               child: Padding(
                                 padding: const EdgeInsets.symmetric(horizontal: 8),
                                 child: FaIcon(FontAwesomeIcons.equals,color: white,),
                               ),
                             ),
                           ],

                          ),
                        ),
                        ListView.builder(
                          shrinkWrap: true,
                          itemCount: students.length,
                          itemBuilder: (context,index){
                            final student = students..sort((item1,item2)=>item1['full_name'].compareTo(item2['full_name']));
                            return Padding(
                              padding: const EdgeInsets.fromLTRB(0,0,0,3),
                              child: ListTile(
                                tileColor:  tileColor[index] ,
                                leading: Text('${index+1}'),
                                title: Text(student[index]['full_name']),
                                trailing: Container(
                                  width: 180,
                                  child: Row(
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.symmetric(horizontal: 5),
                                        child: ElevatedButton(
                                            onPressed: (){
                                              AttendanceRecord[index] ={
                                                "id" :"${student[index]['id']}",
                                                "name" :"${student[index]['full_name']}",
                                                "status" :"present",
                                              };
                                              print(AttendanceRecord);
                                              print("The record length is");
                                              print(AttendanceRecord.length);
                                              setState(() {
                                                tileColor[index] = green.withOpacity(0.2);
                                              });
                                            },
                                            child: Text("Present"),
                                            style: ElevatedButton.styleFrom(
                                              primary: green,
                                            )
                                        ),

                                      ),

                                      ElevatedButton(
                                          onPressed: (){
                                            AttendanceRecord[index] ={
                                              "id" :"${student[index]['id']}",
                                              "name" :"${student[index]['full_name']}",
                                              "status" :"absent",
                                            };
                                            print(AttendanceRecord);
                                            print(AttendanceRecord[0]);
                                            setState(() {
                                              tileColor[index]  = red.withOpacity(0.2);
                                            });
                                          },
                                          child: Text("Absent"),
                                          style: ElevatedButton.styleFrom(
                                            primary: red,
                                          )
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            );
                          }
                        ),

                        // Padding(
                        //   padding: const EdgeInsets.fromLTRB(0,0,0,3),
                        //   child: ListTile(
                        //     tileColor: tileColor2,
                        //     title: Text("2,         Abiral Pokhrel"),
                        //     trailing: Container(
                        //       width: 180,
                        //       child: Row(
                        //         children: [
                        //           Padding(
                        //             padding: const EdgeInsets.symmetric(horizontal: 5),
                        //             child: ElevatedButton(
                        //                 onPressed: (){
                        //                   setState(() {
                        //                     tileColor2 = green.withOpacity(0.2);
                        //                   });
                        //                 },
                        //                 child: Text("Present"),
                        //                 style: ElevatedButton.styleFrom(
                        //                   primary: green,
                        //                 )
                        //             ),
                        //
                        //           ),
                        //
                        //           ElevatedButton(
                        //               onPressed: (){
                        //                 setState(() {
                        //                   tileColor2 = red.withOpacity(0.2);
                        //                 });
                        //               },
                        //               child: Text("Absent"),
                        //               style: ElevatedButton.styleFrom(
                        //                 primary: red,
                        //               )
                        //           ),
                        //         ],
                        //       ),
                        //     ),
                        //   ),
                        // ),

                        SizedBox(height: 10,),
                        success ? Text('Attendance Taken Successfully',style: TextStyle(fontSize: 16,color: green),):Container(),
                        error != '' ? Text(error,style: TextStyle(fontSize: 16,color: red),):Container(),
                        SizedBox(
                          height: 10,
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 10),
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              primary: blue
                            ),
                              onPressed: (){TakeAttendance();},
                              child: loading ? Padding(
                                padding: const EdgeInsets.fromLTRB(0,0,0,0),
                                child: SizedBox(
                                    height: 15,
                                    width: 15,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                      color: white,
                                    )),
                              ):Text("Submit",style:TextStyle(fontSize: 18),
                          ),
                        ),
                        ),

                      ],
                    ),
                  ),
            ],
          ),
        ),
    );
  }
}

DropdownMenuItem<String> buildMenuItem(String faculty){
  return DropdownMenuItem(
      value: faculty,
      child: Text(
        faculty,
      ));

}