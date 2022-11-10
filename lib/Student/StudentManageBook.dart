import 'dart:convert';

import 'package:eacademia/Colors.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import '../Connection/conn.dart';
class StudentManageBook extends StatefulWidget {
  const StudentManageBook({Key? key}) : super(key: key);

  @override
  State<StudentManageBook> createState() => _StudentManageBookState();
}

class _StudentManageBookState extends State<StudentManageBook> {
  int i =0;

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
      getBooks();
      print(response.statusCode);
    }
    catch (e) {
      print(e);
    }
  }
  bool loading =false;
  bool success = false;
  var books =[];
  String classId='';
  getBooks() async {

    var response1;
    var response2;
    setState(() {
      books=[];
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
        Uri.parse("http://$host:8000/books/"),
        headers: {
          'Authorization' : 'Bearer $access_token'
        },
      );
      var data2 = jsonDecode(response2.body.toString());
      for(int i=0;i<data2.length;i++){
        if(data2[i]['grade'].toString()== classId){
          setState(() {
            books.add(data2[i]);
          });

        }
      }
      for(int i=0;i<books.length;i++){
        setState(() {
          checker[i] =false;
        });
      }
      print(books);
      print(books.length);
      print(books[0]['name']);
      setState(() {
        loading = false;
        success = true;
      });
    }
    catch(e){
        print(e);
    }
  }
  bool checker1 =false;
  bool checker2 =false;
  bool checker3 =false;
  var checker={};
  @override
  Widget build(BuildContext context) {
    return Container(

      child: SingleChildScrollView(
        child: Container(
          color: lightBlue.withOpacity(0.2),
          height: Get.height,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(10,20,10,10),
                  child: Text("Book List",style: TextStyle(fontSize: 20,fontWeight: FontWeight.w500),),
                ),
                ListView.builder(
                  shrinkWrap: true,
                  itemCount: books.length,
                  itemBuilder: (context,index){
                    return Card(
                      child: ListTile(
                        onTap: (){
                          setState(() {});
                          checker[index]=!checker[index];
                          Scaffold.of(context).showSnackBar(
                              SnackBar(
                                  behavior: SnackBarBehavior.floating,
                                  width: 350,
                                  duration: const Duration(milliseconds: 1000),
                                  backgroundColor: checker[index] ? green :red,
                                  elevation: 0,
                                  content:  checker[index] ?Container(
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10),
                                      color: green,
                                    ),
                                    child: ListTile(
                                      leading: FaIcon(FontAwesomeIcons.solidCircleCheck,color: white,size: 40,),
                                      title:  Text("Success",style: TextStyle(fontWeight: FontWeight.w700,color: white),),
                                      subtitle: Text("Reminder for the book is set ",style: TextStyle(color: white),),

                                    ),
                                  ) :
                                  Container(
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(30),
                                      color: red,
                                    ),
                                    child: ListTile(
                                      leading:
                                      Icon(Icons.highlight_remove_outlined,color: white,size: 40,),
                                      title:  Text("Reminder Removed",style: TextStyle(fontWeight: FontWeight.w700,color: white),),
                                      subtitle: Text("Reminder for the book was removed ",style: TextStyle(color: white),),

                                    ),
                                  )
                              )
                          );
                        },
                        title: Text(books[index]['name']),
                        subtitle: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8.0),
                          child: Text("Code:" + books[index]['code_number']),
                        ),
                        trailing:checker[index] == true ? FaIcon(FontAwesomeIcons.solidCircleCheck,color: green,):FaIcon(FontAwesomeIcons.solidCircleCheck),
                      ),
                    );
                  }
                  // children: [
                  //
                  // ],
                ),
                // Card(
                //   child: ListTile(
                //     onTap: (){
                //       setState(() {});
                //       checker2=!checker2;
                //       Scaffold.of(context).showSnackBar(
                //           SnackBar(
                //               behavior: SnackBarBehavior.floating,
                //               width: 350,
                //               duration: const Duration(milliseconds: 1000),
                //               backgroundColor: checker2 ? green :red,
                //               elevation: 0,
                //               content:  checker2 ?Container(
                //                 decoration: BoxDecoration(
                //                   borderRadius: BorderRadius.circular(10),
                //                   color: green,
                //                 ),
                //                 child: ListTile(
                //                   leading: FaIcon(FontAwesomeIcons.solidCircleCheck,color: white,size: 40,),
                //                   title:  Text("Success",style: TextStyle(fontWeight: FontWeight.w700,color: white),),
                //                   subtitle: Text("Reminder for the book is set for 25th October ",style: TextStyle(color: white),),
                //
                //                 ),
                //               ) :
                //               Container(
                //                 decoration: BoxDecoration(
                //                   borderRadius: BorderRadius.circular(30),
                //                   color: red,
                //                 ),
                //                 child: ListTile(
                //                   leading:
                //                   Icon(Icons.highlight_remove_outlined,color: white,size: 40,),
                //                   title:  Text("Reminder Removed",style: TextStyle(fontWeight: FontWeight.w700,color: white),),
                //                   subtitle: Text("Reminder for the book was removed ",style: TextStyle(color: white),),
                //
                //                 ),
                //               )
                //           )
                //       );
                //     },
                //     title: Text("Engineering Economics"),
                //     subtitle: Padding(
                //       padding: const EdgeInsets.symmetric(vertical: 8.0),
                //       child: Text("Text Book"),
                //     ),
                //     trailing:checker2 == true ? FaIcon(FontAwesomeIcons.solidCircleCheck,color: green,):FaIcon(FontAwesomeIcons.solidCircleCheck),
                //   ),
                // ),
                // Card(
                //   child: ListTile(
                //     onTap: (){
                //       setState(() {});
                //       checker3=!checker3;
                //       Scaffold.of(context).showSnackBar(
                //           SnackBar(
                //               behavior: SnackBarBehavior.floating,
                //               width: 350,
                //               duration: const Duration(milliseconds: 1000),
                //               backgroundColor: checker3 ? green :red,
                //               elevation: 0,
                //               content:  checker3 ?Container(
                //                 decoration: BoxDecoration(
                //                   borderRadius: BorderRadius.circular(10),
                //                   color: green,
                //                 ),
                //                 child: ListTile(
                //                   leading: FaIcon(FontAwesomeIcons.solidCircleCheck,color: white,size: 40,),
                //                   title:  Text("Success",style: TextStyle(fontWeight: FontWeight.w700,color: white),),
                //                   subtitle: Text("Reminder for the book is set for 25th October ",style: TextStyle(color: white),),
                //
                //                 ),
                //               ) :
                //               Container(
                //                 decoration: BoxDecoration(
                //                   borderRadius: BorderRadius.circular(30),
                //                   color: red,
                //                 ),
                //                 child: ListTile(
                //                   leading:
                //                   Icon(Icons.highlight_remove_outlined,color: white,size: 40,),
                //                   title:  Text("Reminder Removed",style: TextStyle(fontWeight: FontWeight.w700,color: white),),
                //                   subtitle: Text("Reminder for the book was removed ",style: TextStyle(color: white),),
                //
                //                 ),
                //               )
                //           )
                //       );
                //     },
                //     title: Text("Engineering Economics"),
                //     subtitle: Padding(
                //       padding: const EdgeInsets.symmetric(vertical: 8.0),
                //       child: Text("Text Book"),
                //     ),
                //     trailing:checker3 == true ? FaIcon(FontAwesomeIcons.solidCircleCheck,color: green,):FaIcon(FontAwesomeIcons.solidCircleCheck),
                //   ),
                // ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

