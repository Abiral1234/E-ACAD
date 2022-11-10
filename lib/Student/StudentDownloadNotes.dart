import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import '../Colors.dart';
import '../Connection/conn.dart';
class StudentDownloadNotes extends StatefulWidget {
  const StudentDownloadNotes({Key? key}) : super(key: key);

  @override
  State<StudentDownloadNotes> createState() => _StudentDownloadNotesState();
}

class _StudentDownloadNotesState extends State<StudentDownloadNotes> {
  // String? value = faculty[0];
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
    getStudentInformation();
  }

  List classes=[];
  var batch_list=[
    'Select a batch',
  ];
  String value = 'Select a batch';

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
      getNotes();
      print(response.statusCode);
    }
    catch (e) {
      print(e);
    }
  }
  bool loading =false;
  bool success = false;
  var notes =[];
  String classId='';
  getNotes() async {
    var response1;
    var response2;
    setState(() {
      notes=[];
      loading = true;
    });
    try {
      setState(() {
        loading = true;
      });
      print(access_token);
      response1 = await http.get(
        Uri.parse("http://$host:8000/class/"),
        headers: {
          'Authorization' : 'Bearer $access_token'
        },
      );

      var data1 = jsonDecode(response1.body.toString());
      for(int i=0;i<data1.length;i++){
        if(batchName==data1[i]['faculty']+"_"+data1[i]['year']){
          classId = data1[i]['id'].toString();
        }
      }

      response2 = await http.get(
        Uri.parse("http://$host:8000/teacher/notes/"),
        headers: {
          'Authorization' : 'Bearer $access_token'
        },
      );
      var data2 = jsonDecode(response2.body.toString());
      for(int i=0;i<data2.length;i++){
        if(data2[i]['subject']['subject']['id'].toString()== classId){
          setState(() {
            notes.add(data2[i]);
          });

        }
      }
      // for(int i=0;i<books.length;i++){
      //   setState(() {
      //     checker[i] =false;
      //   });
      // }
      // print(books);
      // print(books.length);
      // print(books[0]['name']);
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
    return SingleChildScrollView(
      child: Container(
        color: lightBlue.withOpacity(0.2),
        child:
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(10,20,10,10),
                child: Text("Downloads:",style: TextStyle(fontSize: 20,fontWeight: FontWeight.w500),),
              ),
              ListView.builder(
                shrinkWrap: true,
                itemCount: notes.length,
                itemBuilder:(context,index) {
                  return
                    Card(
                      child: ListTile(
                        onTap: () {
                          setState(() {});
                        },
                        title: Text(notes[index]['title']),
                        subtitle: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8.0),
                          child: Text(notes[index]["subject"]["subject_name"]),
                        ),
                      ),
                    );
                }
              ),

            ],
          ),
        ),
      ),
    );
  }
}
