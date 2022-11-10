import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import '../Colors.dart';
import '../Connection/conn.dart';
import '../Fonts.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_phone_direct_caller/flutter_phone_direct_caller.dart';

class TeacherCallerList extends StatefulWidget {
  const TeacherCallerList({Key? key}) : super(key: key);

  @override
  State<TeacherCallerList> createState() => _TeacherCallerListState();
}

class _TeacherCallerListState extends State<TeacherCallerList> {
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
    getBatches();
  }
  var batch_list=[
    'Select a batch',
  ];
  String value = 'Select a batch';
  var classes=[];
  getBatches() async{
    var response;
    setState(() {
      loading = true;
    });
    try {
      setState(() {
        loading = true;
      });
      print("The access token is");
      print(access_token);
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
        for(int i=2 ; i<classes.length;i++){
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
  bool loading =false;
  bool success = false;

  var students=[];
  getStudentsPhoneNumber(String batchName) async{
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
      for(int i=0;i<data.length;i++){
        if(data[i]['batch_name'] == batchName){
          setState(() {
            students.add(data[i]);
          });

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
  TextEditingController aboutAdmin = new TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backwardsCompatibility: false,
        title: Text('Caller List',style: fontStyle, ),
        backgroundColor: blue,
        elevation: 0,
        excludeHeaderSemantics: true,
        foregroundColor: Colors.white,

      ),
      body:Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(10,10,10,0),
            child: Container(
              padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border.all(color: grey5),
                borderRadius: BorderRadius.circular(5),
              ),
              child: DropdownButtonHideUnderline(
                child: DropdownButton<String>(
                    iconSize: 35,
                    icon: Icon(Icons.arrow_drop_down_sharp),
                    value: value,
                    isExpanded: true,
                    items: batch_list.map(buildMenuItem).toList(),
                    onChanged: (value){ setState(() {
                      this.value=value!;

                      getStudentsPhoneNumber(value);
                    });}
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: ListView.builder(
              shrinkWrap: true,
                itemCount: students.length,
                itemBuilder: (BuildContext context, int index) {
                  return
                    Column(
                      children: [
                        Card(
                          child: ListTile(
                            title: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(students[index]["full_name"] ,
                                  style: GoogleFonts.manrope(
                                      fontWeight: FontWeight.bold),),
                                SizedBox(height: 8,),
                                Text(students[index]["contact"],
                                  style: GoogleFonts.manrope(
                                      color: grey1, fontSize: 14),),
                                SizedBox(height: 8,),
                                // Text("3 days ago"),
                                SizedBox(height: 8,),
                              ],
                            ),
                            onTap: () {
                              // await FlutterPhoneDirectCaller.callNumber(students[index]["contact"]);
                              // launch('tel://21213123123');
                              launch('tel://${students[index]["contact"]}');
                            },

                          ),
                        ),
                        SizedBox(height: 5),
                      ],
                    );
                }
            ),
          ),
        ],
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