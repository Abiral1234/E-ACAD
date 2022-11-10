import 'package:eacademia/Teacher/ClassPages/ClassAssignment.dart';
import 'package:eacademia/Teacher/ClassPages/ClassMessage.dart';
import 'package:eacademia/Teacher/TeacherHome.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../Colors.dart';
import '../../Fonts.dart';
import '../../Teacher/ClassPages/ClassNotes.dart';
import '../StudentHome.dart';
import 'StudentClassAssignment.dart';
import 'StudentClassHome.dart';
import 'StudentClassMessage.dart';
import 'StudentClassNotes.dart';

class StudentClassHomePage extends StatefulWidget {
  String studentId;
  String subjectId;
  String subjectName;
   StudentClassHomePage(this.studentId,this.subjectId,this.subjectName,{Key? key}) : super(key: key);

  @override
  State<StudentClassHomePage> createState() => _StudentClassHomePageState();
}

class _StudentClassHomePageState extends State<StudentClassHomePage> with TickerProviderStateMixin{

  @override
  Widget build(BuildContext context) {
    var _tabController1;
    _tabController1 = TabController(length: 4, vsync: this);
    double height =MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;

    return Scaffold(
      body: CustomScrollView(
        slivers:  <Widget>[
          SliverAppBar(

            floating: true,
            pinned: true,
            title: Text(widget.subjectName,style: GoogleFonts.manrope(fontSize: 16,fontWeight: FontWeight.bold), ),
            backgroundColor: blue,
            elevation: 0,
            excludeHeaderSemantics: true,
            foregroundColor: Colors.white,
            //FIRST Tab BAR

            bottom: TabBar(
                 controller: _tabController1,
                isScrollable: true,
                indicatorWeight: 2,
                unselectedLabelColor: Colors.white,
                labelColor: lightBlue,
                indicatorColor: lightBlue,
                indicatorSize: TabBarIndicatorSize.label ,

                tabs : [
                  Tab(
                      child:Padding(
                        padding: const EdgeInsets.fromLTRB(6,0,6,0),
                        child: Text('Attendance',style: GoogleFonts.manrope(
                          textStyle: TextStyle(fontSize: 16) ,
                          fontWeight: FontWeight.bold,
                        )),
                      )
                  ),
                  Tab(
                      child:Padding(
                        padding: const EdgeInsets.fromLTRB(6,0,6,0),
                        child: Text('Message',style: GoogleFonts.manrope(
                          textStyle: TextStyle(fontSize: 16) ,
                          fontWeight: FontWeight.bold,
                        )),
                      )
                  ),
                  Tab(
                      child:Padding(
                        padding: const EdgeInsets.fromLTRB(6,0,6,0),
                        child: Row(
                          children: [
                            Text('Assignment',style: GoogleFonts.manrope(
                              textStyle: TextStyle(fontSize: 16) ,
                              fontWeight: FontWeight.bold,
                            )),
                            // NotificationIndicator(1),
                          ],
                        ),
                      )
                  ),

                  Tab(
                      child:Padding(
                        padding: const EdgeInsets.fromLTRB(6,0,6,0),
                        child: Text('Notes',style: GoogleFonts.manrope(
                          textStyle: TextStyle(fontSize: 16) ,
                          fontWeight: FontWeight.bold,
                        )),
                      )
                  ),

                ]
            ),

          ),

          SliverList(
              delegate: SliverChildListDelegate(
                  [
                    Container(
                      width: width,
                      height: height-128,
                      child: TabBarView(
                        controller: _tabController1,
                        children: [
                          StudentClassHome(widget.studentId,widget.subjectId,widget.subjectName),
                          StudentClassMessage(widget.subjectId),
                          StudentClassAssignment(widget.subjectId),
                          StudentClassNotes(widget.subjectId),

                        ],
                      ),
                    ),


                  ]
              )),

        ],

      ),
       
    );
  }
}
