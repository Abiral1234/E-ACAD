import 'dart:convert';
import 'package:eacademia/Teacher/TeacherUpdateClass.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../Colors.dart';
import '../Fonts.dart';
import '../TeacherComponents/DefaultTextField.dart';
import 'ClassPages/ClassHomePage.dart';
import 'package:eacademia/Connection/conn.dart';
final faculties=[
  '-- SELECT Class Batch --',
  'BESE_2015',
  'BESE_2016',
  'BESE_2017',
  'BESE_2018',

];
class EditTeacherClass extends StatefulWidget {
  const EditTeacherClass({Key? key}) : super(key: key);

  @override
  State<EditTeacherClass> createState() => _EditTeacherClassState();
}

class _EditTeacherClassState extends State<EditTeacherClass> {
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
    getSubjects();
  }
  bool loading =false;
  bool success = false;
  var allStudents =[];
  var subjects =[];
  getSubjects() async{
    print("The user id is" + user_id);
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
        if(data[i]["created_by"]['user'].toString() == user_id){
          subjects.add(data[i]);
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
  deleteSubject(String subjectId)async{
    try {
      print("The subject id is");
      print(subjectId);
      var response = await http.delete(
          Uri.parse("http://$host:8000/teacher/subject/$subjectId/"),
          headers: {
            'Authorization': 'Bearer $access_token',
          }
      );
    }
    catch(e){
      print(e);
    }
  }
  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Class',style: fontStyle, ),
        backgroundColor: blue,
        elevation: 0,
        excludeHeaderSemantics: true,
        foregroundColor: Colors.white,
      ),
      body: RefreshIndicator(
        onRefresh: ()async{
          subjects =[];
          getSubjects();
        },
        child: ListView.builder(
            shrinkWrap: true,
            itemCount:subjects.length,
            itemBuilder: (context,index){
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 10,horizontal: 10),
                child: Slidable(
                  endActionPane: ActionPane(
                    // A motion is a widget used to control how the pane animates.
                    motion: const ScrollMotion(),
                    // All actions are defined in the children parameter.
                    children:  [
                      // A SlidableAction can have an icon and/or a label.
                      SlidableAction(
                        onPressed: ((context){
                          print("Hello");
                          print(subjects[index]['id']);
                          deleteSubject(subjects[index]['id'].toString());
                        }),
                        backgroundColor: Color(0xFFFE4A49),
                        foregroundColor: Colors.white,
                        icon: Icons.delete,
                        label: 'Delete',
                      ),
                      SlidableAction(
                        onPressed: ((context){
                              Get.to(TeacherUpdateClass(subjectId: subjects[index]['id'].toString(),));
                        }),
                        backgroundColor: const Color(0xFF19D17A),
                        foregroundColor: Colors.white,
                        icon: Icons.edit,
                        label: 'Edit',
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: [
                              Colors.greenAccent.shade400,
                              Colors.greenAccent,
                            ],
                          ),
                          borderRadius: BorderRadius.circular(20),
                          color: green,
                        ),
                        height: 150,
                        width: 800,
                        child: Padding(
                          padding: const EdgeInsets.all(20.0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(subjects[index]['subject_name'],style: TextStyle(color: white,fontSize: 30),),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text('Faculty:'+subjects[index]['subject']['faculty'],style: TextStyle(color: white,fontSize: 16),),
                                  Text('Year:'+subjects[index]['subject']['year'],style: TextStyle(color: white,fontSize: 16),),
                                ],
                              ),
                            ],
                          ),
                        ),

                      ),
                    ],
                  ),
                ),
              );
            }
          //     children: [
          //   Padding(
          //   padding: const EdgeInsets.symmetric(vertical: 25,horizontal: 10),
          //   child:
          //   Column(
          //     children: [
          //
          //       GestureDetector(
          //         onTap: (){
          //           Get.to(ClassHomePage(
          //             subject: "Computer Networ",
          //             batch: "BESE_2023",
          //           ));
          //         },
          //         child: Container(
          //           decoration: BoxDecoration(
          //             gradient: LinearGradient(
          //               begin: Alignment.topLeft,
          //               end: Alignment.bottomRight,
          //               colors: [
          //                 Colors.greenAccent.shade400,
          //                 Colors.greenAccent,
          //               ],
          //             ),
          //             borderRadius: BorderRadius.circular(20),
          //             color: green,
          //           ),
          //           height: 150,
          //           width: 800,
          //           child: Padding(
          //             padding: const EdgeInsets.all(20.0),
          //             child: Column(
          //               mainAxisAlignment: MainAxisAlignment.spaceBetween,
          //               crossAxisAlignment: CrossAxisAlignment.start,
          //               children: [
          //                 Text("Computer Network",style: TextStyle(color: white,fontSize: 20),),
          //                 Row(
          //                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
          //                   children: [
          //                     Text("Software",style: TextStyle(color: white,fontSize: 16),),
          //                     Text("BESE_2023",style: TextStyle(color: white,fontSize: 16),),
          //                   ],
          //                 ),
          //
          //               ],
          //             ),
          //           ),
          //
          //         ),
          //       ),
          //     ],
          //   ),
          // ),
          //     ],
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