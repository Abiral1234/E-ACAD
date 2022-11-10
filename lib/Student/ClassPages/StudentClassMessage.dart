import 'dart:convert';

import 'package:eacademia/AdminComponents/DefaultTextField.dart';
import 'package:eacademia/Colors.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../../Connection/conn.dart';
class StudentClassMessage extends StatefulWidget {
  String subjectId;
  StudentClassMessage(this.subjectId,{Key? key}) : super(key: key);

  @override
  State<StudentClassMessage> createState() => _StudentClassMessageState();
}

class _StudentClassMessageState extends State<StudentClassMessage > {

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
        if(data[i]["subject"]['id'].toString() == widget.subjectId ){
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
    );
  }
}
