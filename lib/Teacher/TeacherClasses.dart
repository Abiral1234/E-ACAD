import 'dart:convert';

import 'package:eacademia/Teacher/ClassPages/ClassHomePage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../Colors.dart';
import 'package:eacademia/Connection/conn.dart';
class TeacherClasses extends StatefulWidget {
  const TeacherClasses({Key? key}) : super(key: key);

  @override
  State<TeacherClasses> createState() => _TeacherClassesState();
}

class _TeacherClassesState extends State<TeacherClasses> {
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
  getSubjects();
  }
  bool loading =false;
  bool success = false;
  var allStudents =[];
  var subjects =[];
  getSubjects() async{
    print("The user id is" + user_id);
    var response;
    setState(() {
      loading = true;
    });
    try {
      setState(() {
        loading = true;
      });
      response = await http.get(
          Uri.parse("http://$host:8000/teacher/subject/"),
          headers: {
            'Authorization': 'Bearer $access_token',
          }
      );
      var data = jsonDecode(response.body.toString());
      for(int i=0;i<data.length;i++){
        if(data[i]["created_by"]['user'].toString() == user_id){
          subjects.add(data[i]);
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
  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: ()async{
        subjects =[];
        getSubjects();
      },
      child: ListView.builder(
        shrinkWrap: true,
        itemCount:subjects.length,
        itemBuilder: (context,index){
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 10,horizontal: 10),
            child:
            Column(
              children: [

                GestureDetector(
                  onTap: (){
                    Get.to(ClassHomePage(
                      subjectId : "${subjects[index]['id']}",
                      subject: subjects[index]['subject_name'],
                      batch: subjects[index]['subject']['faculty']+"_"+subjects[index]['subject']['year'],
                    ));
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          Colors.greenAccent.shade400,
                          Colors.greenAccent,
                        ],
                      ),
                      borderRadius: BorderRadius.circular(20),
                      color: green,
                    ),
                    height: 150,
                    width: 800,
                    child: Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(subjects[index]['subject_name'],style: TextStyle(color: white,fontSize: 30),),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text('#Id:'+'${subjects[index]['id']}',style: TextStyle(color: white,fontSize: 16),),
                              Text(subjects[index]['subject']['faculty']+'_'+subjects[index]['subject']['year'],style: TextStyle(color: white,fontSize: 16),),
                            ],
                          ),

                        ],
                      ),
                    ),

                  ),
                ),
              ],
            ),
          );
        }
      //     children: [
      //   Padding(
      //   padding: const EdgeInsets.symmetric(vertical: 25,horizontal: 10),
      //   child:
      //   Column(
      //     children: [
      //
      //       GestureDetector(
      //         onTap: (){
      //           Get.to(ClassHomePage(
      //             subject: "Computer Networ",
      //             batch: "BESE_2023",
      //           ));
      //         },
      //         child: Container(
      //           decoration: BoxDecoration(
      //             gradient: LinearGradient(
      //               begin: Alignment.topLeft,
      //               end: Alignment.bottomRight,
      //               colors: [
      //                 Colors.greenAccent.shade400,
      //                 Colors.greenAccent,
      //               ],
      //             ),
      //             borderRadius: BorderRadius.circular(20),
      //             color: green,
      //           ),
      //           height: 150,
      //           width: 800,
      //           child: Padding(
      //             padding: const EdgeInsets.all(20.0),
      //             child: Column(
      //               mainAxisAlignment: MainAxisAlignment.spaceBetween,
      //               crossAxisAlignment: CrossAxisAlignment.start,
      //               children: [
      //                 Text("Computer Network",style: TextStyle(color: white,fontSize: 20),),
      //                 Row(
      //                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
      //                   children: [
      //                     Text("Software",style: TextStyle(color: white,fontSize: 16),),
      //                     Text("BESE_2023",style: TextStyle(color: white,fontSize: 16),),
      //                   ],
      //                 ),
      //
      //               ],
      //             ),
      //           ),
      //
      //         ),
      //       ),
      //     ],
      //   ),
      // ),
      //     ],
      ),
    );
  }
}
