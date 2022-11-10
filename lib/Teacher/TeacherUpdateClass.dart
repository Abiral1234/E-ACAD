import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../Colors.dart';
import '../Fonts.dart';
import '../TeacherComponents/DefaultTextField.dart';
import 'package:eacademia/Connection/conn.dart';
final faculties=[
  '-- SELECT Class Batch --',
  'BESE_2015',
  'BESE_2016',
  'BESE_2017',
  'BESE_2018',

];
class TeacherUpdateClass extends StatefulWidget {
  String subjectId;
  TeacherUpdateClass({Key? key,required this.subjectId}) : super(key: key);

  @override
  State<TeacherUpdateClass> createState() => _TeacherUpdateClassState();
}

class _TeacherUpdateClassState extends State<TeacherUpdateClass> {
  @override
  // ignore: must_call_super
  void initState() {
    getToken();
    print("The Subject Id is");
    print(widget.subjectId);

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
    getSubjects();
  }
  List classes=[];
  var batch_list=[
    'Select a batch',
  ];
  String value = 'Select a batch';
  String batchId ='';
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
          Uri.parse("http://$host:8000/teacher/subject/"),
          headers: {
            'Authorization': 'Bearer $access_token',
          }
      );
      var data = jsonDecode(response.body.toString());
      print(data);
      for(int i=0;i<data.length;i++){
        if(data[i]["id"].toString() == widget.subjectId){
          subject.text = data[i]["subject_name"];
          //value = data[i]['subject']['faculty']+"_"+data[i]['subject']['year'];

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

  setBatchId(String batchName)async{
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
          String batchname = classes[i]['faculty']+'_'+classes[i]['year'];
          if(batchname == batchName){
            print("The selected batch id is");
            batchId = classes[i]['id'].toString();
            print(batchId);
          }
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
  getBatches() async{
    var response;
    try {
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
        for(int i=0 ; i<classes.length;i++){
          String batchName = data[i]['faculty']+ "_" +data[i]['year'];
          setState(() {
            batch_list.add(batchName);
          });
        }
        print(batch_list);
      }

    }
    catch(e){
      print(e);
    }
  }

  bool loading =false;
  bool success = false;
  var subjects =[];
  updateClassForTeacher() async {
    var response;
    setState(() {
      loading = true;
    });
    try {
      setState(() {
        loading = true;
      });
      var data ={
        "subject":{
          "id":batchId
        },
        "subject_name" :subject.text
      };
      response = await http.patch(
          Uri.parse("http://$host:8000/teacher/subject/${widget.subjectId}/"),
          headers: {
            'content-type': 'application/json',
            'Authorization': 'Bearer $access_token',
          },
          body: jsonEncode(data)
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
  TextEditingController subject =new TextEditingController();
  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: Text('Update Class',style: fontStyle, ),
        backgroundColor: blue,
        elevation: 0,
        excludeHeaderSemantics: true,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.fromLTRB(20, 30, 20, 20),
          color:  lightBlue.withOpacity(0.2),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children:  [
              Padding(
                padding: const EdgeInsets.fromLTRB(5,0,0,0),
                child: Text('Create Subject',style: TextStyle(fontSize: 18,fontWeight: FontWeight.w400),),
              ),
              SizedBox(
                height: 10,
              ),
              DefaultTextField(hintText: 'Subject Name',controller: subject,),
              SizedBox(
                height: 16,
              ),
              Container(
                padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
                decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(color: grey5),
                  borderRadius: BorderRadius.circular(5),
                ),
                child: DropdownButtonHideUnderline(
                  child:
                  DropdownButton<String>(
                      iconSize: 35,
                      icon: Icon(Icons.arrow_drop_down_sharp),
                      value: value,
                      isExpanded: true,
                      items: batch_list.map(buildMenuItem).toList(),
                      onChanged: (value){ setState(() {
                        this.value=value!;
                        setBatchId(value!);

                      });}
                  ),
                ),
              ),
              SizedBox(height: 10,),
              success ? Text('Class Created Succesfully',style: TextStyle(fontSize: 16,color: green),):Container(),
              SizedBox(
                height: 10,
              ),
              // Padding(
              //   padding: const EdgeInsets.symmetric(vertical: 14.0),
              //   child: ElevatedButton(
              //       style: ElevatedButton.styleFrom(
              //           primary: blue,
              //           minimumSize: Size(800, 40)
              //       ),
              //       onPressed: (){},
              //       child: Row(
              //         mainAxisAlignment: MainAxisAlignment.center,
              //         children: [
              //           Padding(
              //             padding: const EdgeInsets.symmetric(horizontal: 8.0),
              //             child: FaIcon(FontAwesomeIcons.file),
              //           ),
              //           Text("Attach File",style: TextStyle(fontSize: 18),),
              //         ],
              //
              //       )),
              // ),

              ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    primary: blue,
                  ),
                  onPressed: (){updateClassForTeacher();},
                  child: loading ? Padding(
                    padding: const EdgeInsets.fromLTRB(0,0,0,0),
                    child: SizedBox(
                        height: 15,
                        width: 15,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: white,
                        )),
                  ):Text('Update',style: TextStyle(fontSize: 18),)
              ),
              SizedBox(
                height: 10,
              ),
            ],
          ),
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