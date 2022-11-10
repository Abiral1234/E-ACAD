import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../Colors.dart';
import 'package:http/http.dart' as http;
import 'package:eacademia/Connection/conn.dart';

class Language extends StatefulWidget {
  const Language({Key? key}) : super(key: key);

  @override
  State<Language> createState() => _LanguageState();
}

class _LanguageState extends State<Language> {

  _goToNotificationList(){
    Navigator.of(context).pushNamed('/Show_Recent_Notification');
  }
  @override
  // ignore: must_call_super
  void initState() {
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

  }
  bool loading =false;
  bool success = false;
  List classes=[];
  getBatches() async{
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
        },
      );
      print(response.body);
      print(response.statusCode);
      if(response.statusCode == 200){
        var data = jsonDecode(response.body.toString());
        classes=data;
        for(int i=0 ; i<classes.length;i++){
          String batchName = data[i]['faculty']+ "_" +data[i]['year'];
          batch_list.add(batchName);
        }

        setState(() {
          loading = false;
        });
      }

    }
    catch(e){
      print(e);
    }
  }

  createLanguage() async {
    var response;
    setState(() {
      loading = true;
    });
    try {
      setState(() {
        loading = true;
      });
      print("The access Token is ");
      print(access_token);
      response = await http.post(
        Uri.parse("http://$host:8000/fee_notifications/"),
        headers: {
          'Authorization': 'Bearer $access_token',
        },
        body: {
          "batch_name": "BESE",
          "message": message.text,
        },
      );
      print(response.body);
      setState(() {
        loading = false;
        success = true;
      });
    }
    catch(e){

    }
  }
  TextEditingController batchname = TextEditingController();
  TextEditingController message = TextEditingController();
  var batch_list=[
    'Select a batch',
  ];
  String value = 'Select a batch';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Language',style: TextStyle(fontFamily: 'Aerial',color: white),),
        backgroundColor:blue,
        elevation: 0,
      ),
      body: Container(
        padding: EdgeInsets.fromLTRB(20, 30, 20, 20),
        color:  lightBlue.withOpacity(0.2),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children:  [
            Padding(
              padding: const EdgeInsets.fromLTRB(5,0,0,0),
              child: Text('Select a language :',style: TextStyle(fontSize: 18),),
            ),
            SizedBox(
              height: 8,
            ),
            RadioListTile(value: 1,
                groupValue: 1,
                onChanged: (value){},
              toggleable: true,
              title: Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: Container(
                      width:40,
                        height: 40,
                        child: Image.asset("assets/flag.png")
                    ),
                  ),
                  Text("  English"),
                ],
              ),
            ),
            SizedBox(
              height: 8,
            ),
            success ? Text('Language selected succesfully',style: TextStyle(fontSize: 16,color: green),):Container(),
            SizedBox(height: 10,),

            SizedBox(
              height: 10,
            ),

          ],
        ),
      ),
    );
  }
}
DropdownMenuItem<String> buildMenuItem(String batch){
  return DropdownMenuItem(
      value: batch,
      child: Text(
        batch,
      ));

}