import 'package:eacademia/Teacher/ClassPages/ClassAssignment.dart';
import 'package:eacademia/Teacher/ClassPages/ClassMessage.dart';
import 'package:eacademia/Teacher/TeacherHome.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../Colors.dart';
import '../../Fonts.dart';
import 'ClassNotes.dart';
import 'package:eacademia/Connection/conn.dart';

class ClassHomePage extends StatefulWidget {
  String subjectId;
  String subject;
  String batch;
   ClassHomePage({Key? key,required this.subjectId,required this.subject,required this.batch}) : super(key: key);

  @override
  State<ClassHomePage> createState() => _ClassHomePageState();
}

class _ClassHomePageState extends State<ClassHomePage> with TickerProviderStateMixin{

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
            title: Text(widget.subject,style: GoogleFonts.manrope(fontSize: 16,fontWeight: FontWeight.bold), ),
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
                        child: Text('Assignment',style: GoogleFonts.manrope(
                          textStyle: TextStyle(fontSize: 16) ,
                          fontWeight: FontWeight.bold,
                        )),
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
                          TeacherHome(subjectId:widget.subjectId ,subject: widget.subject,batch: widget.batch,),
                          ClassMessage(subjectId:widget.subjectId ,subject: widget.subject,batch: widget.batch,),
                          ClassAssignment(subjectId:widget.subjectId ,subject: widget.subject,batch: widget.batch,),
                          ClassNotes(subjectId:widget.subjectId ,subject: widget.subject,batch: widget.batch,),

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
