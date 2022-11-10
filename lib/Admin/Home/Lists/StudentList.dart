import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../Colors.dart';
import 'package:http/http.dart' as http;
import 'package:eacademia/Connection/conn.dart';

import '../addStudent.dart';


class StudentList extends StatefulWidget {
  const StudentList({Key? key}) : super(key: key);

  @override
  State<StudentList> createState() => _StudentListState();
}

class _StudentListState extends State<StudentList> {

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
  bool loading =false;
  bool success = false;




  List classes=[];
  var batch_list=[
    'Select a batch',
  ];
  String value = 'Select a batch';
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


  var allStudents =[];
  var students=[];
  getStudents(String batch) async {
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
          'Authorization' : 'Bearer $access_token'
        },
      );
      var data = jsonDecode(response.body.toString());
      allStudents = data;
      print(allStudents.length);
      for(int i =0 ; i<allStudents.length;i++){
        if(allStudents[i]['batch_name'] == batch){
          students.add(allStudents[i]);
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
  deleteStudent(String StudentId) async {
    var response;
    setState(() {
      loading = true;
    });
    try {
      print("The selected StudentId is");
      print(StudentId);
      setState(() {
        loading = true;
      });
      response = await http.delete(
        Uri.parse("http://$host:8000/auth/student/$StudentId/"),
        headers: {
          'Authorization' : 'Bearer $access_token'
        },
      );
      // var data = jsonDecode(response.body.toString());
      setState(() {
        Get.to(AddStudent());
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
        title: Text('E-ACADEMIA',style: TextStyle(fontFamily: 'Aerial',color: white),),
        backgroundColor: blue,
        elevation: 0,
      ),
      body: RefreshIndicator(
        onRefresh: ()async{},
        child: ListView(
          children: [
            Container(
              color: lightBlue.withOpacity(0.2),
              child: Column(
                children: [
                  Padding(
                     padding: const EdgeInsets.fromLTRB(10,20,10,0),
                    child: Container(
                      padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        border: Border.all(color: grey5),
                        borderRadius: BorderRadius.circular(0),
                      ),
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton<String>(
                            iconSize: 35,
                            icon: Icon(Icons.arrow_drop_down_sharp),
                            value: value,
                            isExpanded: true,
                            items: batch_list.map(buildMenuItem).toList(),
                            onChanged: (value){ setState(() {
                              students=[];
                              getStudents(value!);
                              this.value=value!;
                            });}
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(0,10,0,0),
                    child: Container(
                      color: white,
                      child: Table(
                        border: TableBorder.all(
                          color: grey4,
                          borderRadius: BorderRadius.circular(0),
                        ),
                        columnWidths: {
                          0: FractionColumnWidth(0.12),
                          1: FractionColumnWidth(0.35),
                          2: FractionColumnWidth(0.3),
                          3: FractionColumnWidth(0.15),
                        },
                        children: [
                          buildRow(['No.','Student Name','Registration Number','Edit'],isHeader: true),
                          // buildRow(['1','Abiral Pokhrel','23456789']),
                          // buildRow(['2','Arun Khattri','23456789']),
                          // buildRow(['3','Milan Chhetri','23456789']),
                        ],
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: ListView.builder(
                      shrinkWrap: true,
                        itemCount: students.length,
                        itemBuilder: (BuildContext context, int index){
                          final student = students..sort((item1,item2)=>item1['full_name'].compareTo(item2['full_name']));
                          return Container(
                            color: white,
                            child: Table(
                              border: TableBorder.all(
                                color: grey4,
                                borderRadius: BorderRadius.circular(0),
                              ),
                              columnWidths: {
                                0: FractionColumnWidth(0.12),
                                1: FractionColumnWidth(0.35),
                                2: FractionColumnWidth(0.3),
                                3: FractionColumnWidth(0.15),
                              },
                              children: [
                                TableRow(
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Text('${index+1}'),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Text(student[index]['full_name']),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Text(student[index]['registration_number']),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Row(
                                          children: [
                                            //Icon(Icons.edit,color: green,),
                                            GestureDetector(
                                              onTap:(){
                                                print("Delete Function");
                                                print(student[index]["id"]);
                                                deleteStudent("${student[index]["id"]}");
                                              },

                                              child: Padding(
                                                padding: const EdgeInsets.symmetric(horizontal: 10.0),
                                                child: Icon(Icons.delete,color: red,),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ]
                                )
                              ],
                            ),
                          );
                        }),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
TableRow buildRow(List<String>cells , {bool isHeader =false} ){
  return TableRow(
    children: cells.map((cell) =>
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(cell,style: isHeader ?GoogleFonts.manrope(fontSize: 16,fontWeight: FontWeight.bold)   : GoogleFonts.manrope(fontSize: 16) ,
          ),
        )).toList(),
  );

}
DropdownMenuItem<String> buildMenuItem(String batch){
  return DropdownMenuItem(
      value: batch,
      child: Text(
        batch,

      ));

}