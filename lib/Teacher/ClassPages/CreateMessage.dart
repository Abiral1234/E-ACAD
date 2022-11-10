import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart'as http;
import '../../Colors.dart';
import '../../Connection/conn.dart';
import '../../Fonts.dart';
class CreateMessage extends StatefulWidget {
  String subjectId;
   CreateMessage({Key? key,required this.subjectId}) : super(key: key);

  @override
  State<CreateMessage> createState() => _CreateMessageState();
}

class _CreateMessageState extends State<CreateMessage> {
  TextEditingController teacherMessage = new TextEditingController();
  @override
  // ignore: must_call_super
  void initState() {
    getToken();

  }
  String refresh_token='';
  String access_token='';
  String error='';
  getToken() async{
    final SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    setState(() {
      refresh_token = sharedPreferences.get('refresh_token').toString();
      access_token = sharedPreferences.get('access_token').toString();

    });
    getMessages();
  }
  bool loading =false;
  bool success = false;
  var messages =[];

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
      messages = data;

      setState(() {
        loading = false;

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
          "id":widget.subjectId
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
    return Scaffold(
      appBar: AppBar(
        title: Text('Create Message',style: fontStyle, ),
        backgroundColor: blue,
        elevation: 0,
        excludeHeaderSemantics: true,
        foregroundColor: Colors.white,
      ),
      body:  Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0 ,horizontal: 15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Text("Message",style: fontStyle,),
            SizedBox(height: 10,),
            Container(
              color: Colors.grey.shade50,
              child: DefaultMessageText(
                  "Message....",teacherMessage
              ),
            ),
            SizedBox(height: 20,),
            success ? Text('Message created successfully',style: TextStyle(fontSize: 16,color: green),):Container(),
            error != '' ? Text(error,style: TextStyle(fontSize: 16,color: red),):Container(),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 10),
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                    primary: blue
                ),
                onPressed: (){sendMessages();},
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
    );
  }
}
Widget DefaultMessageText(String hintText , TextEditingController controller){
  return Container(
    decoration: BoxDecoration(
      color: Colors.white,
      border: Border.all(color: grey5),
      borderRadius: BorderRadius.circular(5),
    ),
    child: TextField(
      maxLines: 4,

      controller: controller,
      decoration: InputDecoration(
        contentPadding: EdgeInsets.fromLTRB(10,10,0,0),
        border: InputBorder.none,
        fillColor: Colors.white,
        hintText: hintText,
        hintStyle: TextStyle(color: grey3),
      ),
    ),
  );
}