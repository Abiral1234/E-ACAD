import 'dart:convert';
import 'dart:io';
import 'package:eacademia/AdminComponents/DefaultTextField.dart';
import 'package:eacademia/Colors.dart';
import 'package:eacademia/Teacher/ClassPages/CreateAssignmentPage.dart';
import 'package:eacademia/Teacher/ClassPages/SubmitNotePage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:open_file/open_file.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:eacademia/Connection/conn.dart';
class ClassNotes extends StatefulWidget {
  String subjectId;
  String subject;
  String batch;
  ClassNotes({Key? key,required this.subjectId ,required this.subject,required this.batch}) : super(key: key);

  @override
  State<ClassNotes> createState() => _ClassNotesState();
}

class _ClassNotesState extends State<ClassNotes> {
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
    getNotes();
  }
  bool loading =false;
  bool success = false;
  var notes =[];

  getNotes() async{
    var response;
    setState(() {
      loading = true;
    });
    try {
      setState(() {
        loading = true;
      });
      response = await http.get(
          Uri.parse("http://$host:8000/teacher/notes/"),
          headers: {
            'Authorization': 'Bearer $access_token',
          }
      );
      var data = jsonDecode(response.body.toString());
      for(int i=0;i<data.length;i++){
        if(data[i]["created_by"]['user'].toString() == user_id && data[i]['subject']['subject_name'].toString() == widget.subject){
          notes.add(data[i]);
        }
      }
      print(notes);
      print(notes.length);
      setState(() {
        loading = false;
        success = true;
      });
    }
    catch(e){
      print(e);
    }
  }

  File? file;
  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      body: RefreshIndicator(
        onRefresh: ()async{
          notes=[];
          getNotes();
        },
        child: ListView.builder(
          shrinkWrap: true,
          itemCount: notes.length,
         itemBuilder: (context,index){
            return Padding(
              padding: EdgeInsets.symmetric(horizontal: 10),
              child: Card(
                child: ListTile(
                  onTap: (){
                    //var imageUrl = Uri.parse(notes[index]['file']);
                    //file = File.fromUri(imageUrl);
                    file  = File("assets/male-teacher.png");
                    // openOneFile(
                    //     url: "",
                    //     fileName:"hello.pdf",
                    // );

                  },
                  tileColor: Colors.white,
                  trailing: Icon(Icons.download),
                  title:Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10.0),
                    child: Text(notes[index]['title']),
                  ),
                  subtitle: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10.0),
                    child: Text("Sent by : ${notes[index]['created_by']["full_name"]}"),
                  ),
                ),
              ),
            );
         }

        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Get.to(SubmitNotePage(widget.subjectId));
        },
        backgroundColor: blue,
        child: const Icon(Icons.upload_rounded),
      ),
    );

  }
}
// Future openOneFile({required String url , required String fileName})async{
//   final fil
//
// }