import 'dart:convert';

import 'package:eacademia/Teacher/ClassPages/CreateAssignmentPage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../../Colors.dart';
import 'package:eacademia/Connection/conn.dart';
class ClassAssignment extends StatefulWidget {
  String subjectId;
  String subject;
  String batch;
  ClassAssignment({Key? key,required this.subjectId ,required this.subject,required this.batch}) : super(key: key);

  @override
  State<ClassAssignment> createState() => _ClassAssignmentState();
}

class _ClassAssignmentState extends State<ClassAssignment> {
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
    getAssignments();
  }
  bool loading =false;
  bool success = false;
  var assignments =[];

  getAssignments() async{
    var response;
    setState(() {
      loading = true;
    });
    try {
      setState(() {
        loading = true;
      });
      response = await http.get(
          Uri.parse("http://$host:8000/teacher/assignment/"),
          headers: {
            'Authorization': 'Bearer $access_token',
          }
      );
      print(response.body);
      var data = jsonDecode(response.body.toString());
      for(int i=0;i<data.length;i++){
        if(data[i]["created_by"]['user'].toString() == user_id && data[i]['subject']['subject_name'].toString() == widget.subject){
          assignments.add(data[i]);
        }
      }
      print(assignments);
      print(assignments.length);
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
    return Scaffold(
      body:  ListView.builder(
        itemCount: assignments.length,
        itemBuilder: (context,index){
          return Padding(
            padding: EdgeInsets.symmetric(horizontal: 10),
            child: Card(
              child: ListTile(
                tileColor: Colors.white,
                title: Padding(
                  padding: EdgeInsets.symmetric(vertical : 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(assignments[index]['title']),

                    ],
                  ),
                ),
                subtitle: Padding(
                  padding: EdgeInsets.symmetric(vertical : 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("Assigned Date : ${assignments[index]['assigned_date']}",textAlign: TextAlign.start,),
                      Text("Deadline : ${assignments[index]['deadline_date']}",textAlign: TextAlign.end,),
                    ],
                  ),
                ),
              ),
            ),
          );
        }

          // Padding(
          //   padding: EdgeInsets.symmetric(horizontal: 10),
          //   child: Card(
          //     child: ListTile(
          //       tileColor: Colors.white,
          //       title: Padding(
          //         padding: EdgeInsets.symmetric(vertical : 10),
          //         child: Row(
          //           mainAxisAlignment: MainAxisAlignment.spaceBetween,
          //           children: [
          //             Text("Assignment Title"),
          //             Container(
          //               decoration: BoxDecoration(
          //                 borderRadius: BorderRadius.circular(20),
          //                 color: green,
          //               ),
          //
          //               child: Padding(
          //                 padding: const EdgeInsets.symmetric(vertical: 8.0,horizontal: 10),
          //                 child: Text("Submitted",style: TextStyle(color: Colors.white),),
          //               ),
          //             )
          //           ],
          //         ),
          //       ),
          //       subtitle: Padding(
          //         padding: EdgeInsets.symmetric(vertical : 10),
          //         child: Row(
          //           mainAxisAlignment: MainAxisAlignment.spaceBetween,
          //           children: [
          //             Text("Assigned Date : 2 Aug",textAlign: TextAlign.start,),
          //             Text("Deadline : 6 Aug",textAlign: TextAlign.end,),
          //           ],
          //         ),
          //       ),
          //     ),
          //   ),
          // ),

      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
         Get.to(CreateAssignmentPage(subjectId: widget.subjectId));
        },
        backgroundColor: blue,
        child: const Icon(Icons.add),
      ),
    );
  }
}
