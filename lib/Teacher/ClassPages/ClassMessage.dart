import 'dart:convert';
import 'package:eacademia/AdminComponents/DefaultTextField.dart';
import 'package:eacademia/Colors.dart';
import 'package:eacademia/Teacher/ClassPages/CreateMessage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:eacademia/Connection/conn.dart';

class ClassMessage extends StatefulWidget {
  String subjectId;
  String subject;
  String batch;
   ClassMessage({Key? key,required this.subjectId ,required this.subject,required this.batch}) : super(key: key);

  @override
  State<ClassMessage> createState() => _ClassMessageState();
}

class _ClassMessageState extends State<ClassMessage> {
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
    getMessages();
  }
  bool loading =false;
  bool success = false;
  var messages =[];
  TextEditingController teacherMessage = new TextEditingController();
  getMessages() async{
    var response;
    setState(() {
      loading = true;
    });
    try {
      setState(() {
        loading = true;
      });
      response = await http.get(
          Uri.parse("http://$host:8000/teacher/message/"),
          headers: {
            'Authorization': 'Bearer $access_token',
          }
      );
      var data = jsonDecode(response.body.toString());
      for(int i=0;i<data.length;i++){
        if(data[i]["created_by"]['user'].toString() == user_id && data[i]['subject']['subject_name'].toString() == widget.subject){
          messages.add(data[i]);
        }
      }
      setState(() {
        loading = false;
        success = true;
      });
    }
    catch(e){

    }
  }
  sendMessages() async{

    setState(() {
      loading = true;
    });
    try {
      setState(() {
        loading = true;
      });

      var data = {
        "subject": {
          "id":1
        },
        "message" :teacherMessage.text,
      };
      var response = await http.post(
          Uri.parse("http://$host:8000/teacher/message/"),
          headers: {
            'content-type': 'application/json',
            'Authorization': 'Bearer $access_token',
          },
         body:  jsonEncode(data)
      );
      print(response.body);
      print(response.statusCode);

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
    return  Scaffold(
      body: RefreshIndicator(
        onRefresh: ()async{
          messages=[];
          await getMessages();
        },
        child: Padding(
          padding: const EdgeInsets.fromLTRB(0,0,0,50),
          child: ListView.builder(
            itemCount: messages.length,
            shrinkWrap: true,
            itemBuilder: (context ,index)
            {
              //print(index);
              int counter = messages.length-index-1;
              return  Padding(
              padding: EdgeInsets.symmetric(horizontal: 10),
              child: Card(
              child: ListTile(
              tileColor: Colors.white,
              title: Padding(
              padding: EdgeInsets.symmetric(vertical : 10),
              child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
              Text(messages[counter]['message']),
              Container(
              decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              color: green,
              ),

              child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0,horizontal: 10),
            child: Text("New",style: TextStyle(color: Colors.white),),
            ),
            )
            ],
            ),
            ),
            subtitle: Padding(
            padding: EdgeInsets.symmetric(vertical : 10),
            child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
            Text("Sent by: ${messages[counter]['created_by']['full_name']}",textAlign: TextAlign.start,),
            Text("Sent:Yesterday",textAlign: TextAlign.end,),
            ],
            ),
            ),
            ),
            ),
            );
            }
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Get.to(CreateMessage(subjectId: widget.subjectId,));
        },
        backgroundColor: blue,
        child: const FaIcon(FontAwesomeIcons.solidMessage),
      ),

    );
  }
}
