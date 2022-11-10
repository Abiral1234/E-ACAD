import 'dart:convert';
import 'package:eacademia/StudentComponent/AssignementListTile.dart';
import 'package:eacademia/StudentComponent/messageListTile.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:math';
import '../Colors.dart';
import 'package:flutter/painting.dart';
import 'package:http/http.dart' as http;
import '../Connection/conn.dart';
import '../Fonts.dart';
import 'ClassPages/StudentClassHomePage.dart';
class StudentHome extends StatefulWidget {
  const StudentHome({Key? key}) : super(key: key);

  @override
  State<StudentHome> createState() => _StudentHomeState();
}

class _StudentHomeState extends State<StudentHome> {
  @override
  // ignore: must_call_super
  void initState() {

    getToken();

  }
  String refresh_token='';
  String access_token='';
  String userId = "";
  String email ='';
  bool loading = false;
  getToken() async{
    final SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    setState(() {
      refresh_token = sharedPreferences.get('refresh_token').toString();
      access_token = sharedPreferences.get('access_token').toString();
      userId = sharedPreferences.get('user_id').toString();
      email = sharedPreferences.get('email').toString();

    });

     getStudentInformation();



  }
  String studentId= '';
  String fullName ='';
  String regNumber ='';
  String batchName ='';
  String contact ='';
  String dob ='';

  getStudentInformation()async{
    try{
      var response = await http.get(
        Uri.parse("http://$host:8000/auth/student-list/"),
        headers: {
          'Authorization': 'Bearer $access_token',
        },
      );
      var data = jsonDecode(response.body.toString());
      for(int i =0; i<data.length;i++){
        if(data[i]["user"]["email"] == email){
          setState(() {
            studentId = data[i]['id'].toString();
            fullName = data[i]['full_name'].toString();
            regNumber =data[i]['registration_number'].toString();
            batchName =data[i]['batch_name'].toString();
            contact =data[i]['contact'].toString();
            dob =data[i]['dob'].toString();
          });
        }
      }
      print(response.statusCode);
      getBatchSubject();
      await getAllClassAssignments();

    }
    catch(e){
      print(e);
    }
  }
  var subjects=[];
  List<int> presentDays =[0,0,0,0,0,0,0,0,0,0,0,0];
  List<int>  totalDays =[0,0,0,0,0,0,0,0,0,0,0,0];
  List<int> absentDays =[0,0,0,0,0,0,0,0,0,0,0,0];
  var attendence=[];
  getBatchSubject()async{
    try{
      var response = await http.get(
        Uri.parse("http://$host:8000/teacher/subject/"),
        headers: {
          'Authorization': 'Bearer $access_token',
        },
      );
      List batch =batchName.split('_');
      String faculty =batch[0];
      String year =batch[1];

      var data = jsonDecode(response.body.toString());
      for(int i =0; i<data.length;i++){
        if(data[i]['subject']['faculty'] == faculty && data[i]['subject']["year"] == year){
              setState(() {
                subjects.add(data[i]);
              });

        }
      }

      var response2 = await http.get(
        Uri.parse("http://$host:8000/teacher/attendence/"),
        headers: {
          'Authorization': 'Bearer $access_token',
        },
      );
      var data2 = jsonDecode(response2.body.toString());
      // print(data[0]);
      // print(data2[0]);
      attendence=data2;
      print(absentDays);
      print(totalDays);
      print("subject length is ");
      print(subjects.length);
      print("Attendance legnth is");
      print(attendence.length);
      print("Student Id is");
      print(studentId);
      for(int i =0; i<subjects.length;i++){
        for(int j=0;j<attendence.length;j++){
          if(attendence[j]['subject']['id'] ==subjects[i]['id'] && attendence[j]['student']['id'].toString() == studentId){
            setState(() {
              totalDays[i] =totalDays[i]+1;
            if(attendence[j]['status'] =='present'){
                presentDays[i]=presentDays[i]+1;
            }
              if(attendence[j]['status'] =='absent'){
                absentDays[i]=absentDays[i]+1;
              }
            });
          }
        }
      }
      print("Attendance for the subjects are:");
      print(presentDays);
      print(absentDays);
      print(totalDays);

    }
    catch(e){
      print(e);
    }
  }
  // getSubjectsOfTheStudent() async{
  //    try{
  //      var response = await http.get(
  //       Uri.parse("http://$host:8000/teacher/subject/"),
  //       headers: {
  //         'Authorization': 'Bearer $access_token',
  //       },
  //     );
  //     // print(response.body);
  //     // print(response.statusCode);
  //
  //   }
  //   catch(e){
  //      print(e);
  //   }
  // }
  var assignments =[];
  getAllClassAssignments()async{
      try{
        var response = await http.get(
          Uri.parse("http://$host:8000/teacher/assignment/"),
          headers: {
            'Authorization': 'Bearer $access_token',
          },
        );
        List batch =batchName.split('_');
        String faculty =batch[0];
        String year =batch[1];
        print("The assignment of the batch are:");
        var data = jsonDecode(response.body.toString());
        // print(data);
        for(int i=0; i < data.length ;i++){
          if(data[i]['subject']['subject']['faculty'] == faculty && data[i]['subject']['subject']['year'] == year){
            assignments.add(data[i]);
          }
        }
        await getAllClassMessages();
      }

      catch(e){
        print(e);
      }
  }
  var messages=[];
  getAllClassMessages()async{
    try{
      var response = await http.get(
        Uri.parse("http://$host:8000/teacher/message/"),
        headers: {
          'Authorization': 'Bearer $access_token',
        },
      );
      List batch =batchName.split('_');
      String faculty =batch[0];
      String year =batch[1];
      // print("The message of the batch are:");
      var data = jsonDecode(response.body.toString());
      // print(data);
      for(int i=0; i < data.length ;i++){
        if(data[i]['subject']['subject']['faculty'] == faculty && data[i]['subject']['subject']['year'] == year){
          messages.add(data[i]);
        }
      }
      // print(messages);

    }
    catch(e){
      print(e);
    }

  }
  getPresentDaysOfTheSubject()async{
    try{
      var response = await http.get(
        Uri.parse("http://$host:8000/teacher/attendence/"),
        headers: {
          'Authorization': 'Bearer $access_token',
        },
      );
      var data = jsonDecode(response.body.toString());

    }
    catch(e){
      print(e);
    }

  }
  double percentageValue = 0.75;

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: ()async{
        presentDays =[0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0];
         totalDays =[0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0];
         absentDays =[0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0];
        subjects=[];
        initState();
      },
      child: SingleChildScrollView(
        child: Container(
          color: lightBlue.withOpacity(0.2),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Container(
                width: 800,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.fromLTRB(25,10,10,20),
                      child: Text("Attendance",style: fontStyle),
                    ),
                    Container(
                      height: 170,
                      child: ListView.builder(
                        shrinkWrap: true,
                        scrollDirection:Axis.horizontal ,
                        itemCount: subjects.length,
                        itemBuilder: (context,index){
                          return Padding(
                            padding: const EdgeInsets.symmetric(vertical: 2),
                            child: AttendanceIndicator(subjects[index]["subject_name"],presentDays[index],totalDays[index]),
                          );
                        }


                      ),
                    )
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Divider(

                ),
              ),
              SizedBox(height: 10),
              Container(
                width: 800,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 25.0),
                      child: Text("Classes",style: fontStyle,
                      //TextStyle(fontSize: 20,fontWeight: FontWeight.w500
                        // ),
                        ),
                    ),
                    SizedBox(height: 10,),
                    ListView.builder(
                        physics: const NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemCount: subjects.length,
                        itemBuilder: (context,index){
                        return GestureDetector(
                          onTap: (){Get.to(StudentClassHomePage(studentId ,subjects[index]["id"].toString() , subjects[index]["subject_name"] , ));},
                          child: ClassBox(subjects[index]["subject_name"],0),
                        );
                        }
                    ),
                  ],
                ),

              ),
              SizedBox(
                height: 15,
              ),
              Divider(),
              SizedBox(
                height: 15,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.blue.shade50,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      children: [
                        Container(
                          width: 800,
                          child: Padding(
                            padding: const EdgeInsets.all(0.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text("Latest assignment",style: TextStyle(fontSize: 20,fontWeight: FontWeight.w500),),
                                    Text("View all",style: TextStyle(fontSize: 18,fontWeight: FontWeight.w400,color: blue),),
                                  ],
                                ),
                                SizedBox(height: 10,),
                                ListView.builder(
                                    physics: const NeverScrollableScrollPhysics(),
                                  shrinkWrap: true,
                                  itemCount: assignments.length<2? assignments.length:2,
                                    itemBuilder: (context,index){
                                    return  AssignmentListTile(assignments[index]['title'], assignments[index]['assigned_date'], assignments[index]['deadline_date'], false);
                                    }
                                ),

                                // AssignmentListTile("Do This Question", "Engineering Economics", "6th Aug", true),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(10, 20, 10, 0),
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.blue.shade50,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      children: [
                        Container(
                          width: 800,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text("Latest message",style: TextStyle(fontSize: 20,fontWeight: FontWeight.w500),),
                                  Text("View all",style: TextStyle(fontSize: 18,fontWeight: FontWeight.w400,color: blue),),
                                ],
                              ),
                              SizedBox(height: 10,),
                              ListView.builder(
                                  physics: const NeverScrollableScrollPhysics(),
                                  shrinkWrap: true,
                                  itemCount: messages.length<2? messages.length:2,
                                  itemBuilder: (context,index){
                                    return  messageListTile(messages[index]['message'], messages[index]['created_by']['full_name'], "2 mins ago", true);
                                  }
                              ),
                              // messageListTile("No Class Today", "Engineering Economics", "2 mins ago", true),
                              // messageListTile("No Class Today", "OOSD", "2 hours ago", false),

                            ],
                          ),
                        ),

                      ],
                    ),
                  ),
                ),
              ),

            ],
          ),
        ),
      ),
    );
  }
}


Widget AttendanceIndicator(String className ,int presentDays, int totalDays ){
  double percentFraction;
  if(totalDays == 0){
    percentFraction = 0;
  }
  else {
    percentFraction = (presentDays / totalDays);
  }
  return  Padding(
    padding: const EdgeInsets.symmetric(horizontal: 15.0),
    child: Column(
      children: [
        CircularPercentIndicator(
          radius: 100,
          lineWidth: 8,
          percent: percentFraction,
          progressColor: percentFraction > 0.70 ? green :red,
          backgroundColor: grey6,
          circularStrokeCap: CircularStrokeCap.round,
          center: Text((percentFraction*100).toInt().toString()+"%",style: TextStyle(fontSize: 20),),
          animateFromLastPercent: true ,
          animation: true,
          animationDuration: 1000,
        ),
        SizedBox(height: 10),
        Container(
          width: 90,
            child: Align(
              alignment: Alignment.center,
                child: Text(className,style: TextStyle(fontSize: 14,),textAlign: TextAlign.center,)
            )),
        SizedBox(height: 10),
      ],
    ),
  );



}

Widget ClassBox(String className, int numberOfNotification){
  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 15),
    child: Card(
      elevation: 1.5,
      shadowColor: Colors.black,
      borderOnForeground: true,
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              lightBlue,
              Colors.deepPurple.shade50,
              //Colors.primaries[Random().nextInt(Colors.primaries.length)],
              //Colors.primaries[Random().nextInt(Colors.primaries.length)],
            ],
          ),
          // borderRadius: BorderRadius.circular(10),
        ),
        child: ListTile(
            title: Row(
              children: [
                Text(className,style: TextStyle(fontSize:18,fontWeight: FontWeight.w500,color: Colors.black),),
                NotificationIndicator(numberOfNotification),

              ],
            ),
        trailing: FaIcon(FontAwesomeIcons.circleArrowRight,color: Colors.blue.shade900,size: 25,),
        ),


      ),
    ),
  );
}

Widget NotificationIndicator(int numberOfNotification){
  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 10.0),
    child: numberOfNotification == 0 ? Container():Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: red,
      ),
      height: 25,
      width: 25,
      child: Center(child: Text(numberOfNotification.toString(),style: TextStyle(color: white),)),

    ),
  );
}