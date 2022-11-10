import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import '../../../Colors.dart';
import 'package:eacademia/Connection/conn.dart';

class TeacherList extends StatefulWidget {
  const TeacherList({Key? key}) : super(key: key);

  @override
  State<TeacherList> createState() => _TeacherListState();
}

class _TeacherListState extends State<TeacherList> {
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
    getTeacher();
  }
  bool loading =false;
  bool success = false;
  var teachers =[];
  getTeacher() async {
    var response;
    setState(() {
      loading = true;
    });
    try {
      setState(() {
        loading = true;
      });
      print(access_token);
      response = await http.get(
        Uri.parse("http://$host:8000/auth/teacher/"),
        headers: {
          'Authorization' : 'Bearer $access_token'
        },
      );
      var data = jsonDecode(response.body.toString());
      teachers = data;
      print(teachers.length);
      print(teachers);
      setState(() {
        loading = false;
        success = true;
      });
    }
    catch(e){
      print(e);
    }
  }
  deleteTeacher(String TeacherId) async {
    var response;
    setState(() {
      loading = true;
    });
    try {
      print("The selected TeacherId is");
      print(TeacherId);
      setState(() {
        loading = true;
      });
      response = await http.delete(
        Uri.parse("http://$host:8000/auth/teacher/$TeacherId/"),
        headers: {
          'Authorization' : 'Bearer $access_token'
        },
      );
      // var data = jsonDecode(response.body.toString());
      setState(() {
        getToken();
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
      onRefresh: ()async{

    },
    child:ListView(
        children: [
          Container(
          color: lightBlue.withOpacity(0.2),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(10,20,10,0),
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
                  buildRow(['No.','Teacher Name','Contact Number','Edit'],isHeader: true),
                  // buildRow(['1','Sujan Tamrakar','9342394329']),
                  // buildRow(['2','Bikash Bhattarai','9342344329']),
                  // buildRow(['3','Pratikshya Poudel','9342224329']),
                ],
              ),
            ),
          ),
        ),
          Padding(
            padding: const EdgeInsets.fromLTRB(10,0,10,0),
            child: Container(
              height: 1000,
              child: ListView.builder(
                  itemCount: teachers.length,
                  itemBuilder: (BuildContext context, int index){
                    // final teacher= teachers[index];
                    final teacher = teachers..sort((item1,item2)=>item1['full_name'].compareTo(item2['full_name']));
                    print(teacher);
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
                                  child: Text(teacher[index]['full_name']),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(teacher[index]['contact']),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Row(
                                    children: [
                                      //Icon(Icons.edit,color: green,),
                                      GestureDetector(
                                        onTap:(){
                                          print("Delete Function");
                                          print(teacher[index]["id"]);
                                          deleteTeacher("${teacher[index]["id"]}");
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
          ),],
      ),),
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
