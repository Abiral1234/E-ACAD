import 'dart:ui';
import 'package:eacademia/AdminComponents/Cards.dart';
import 'package:eacademia/AdminComponents/Admin.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter/material.dart';
import '../Colors.dart';
import '../Fonts.dart';
import 'Home/addClass.dart';
import 'package:eacademia/Connection/conn.dart';

class AdminHome extends StatefulWidget {
  const AdminHome({Key? key}) : super(key: key);

  @override
  State<AdminHome> createState() => _AdminHomeState();
}

class _AdminHomeState extends State<AdminHome> {
  @override
  Widget build(BuildContext context) {
    double height =MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return Container(

        color: lightBlue.withOpacity(0.2),
        width: double.infinity,
        height: double.infinity,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(0,0,0,0),
          child: Wrap(
            alignment: WrapAlignment.start,
          children: [

            GestureDetector(
              onTap: (){Navigator.of(context).pushNamed('/Add_Class'); },
                child: Cards('assets/classroom.svg','Add Class')
            ),

            GestureDetector(
              onTap: (){Navigator.of(context).pushNamed('/Add_Teacher'); },
              child: Cards('assets/teacher.svg','Add Teacher'),
            ),

            GestureDetector(
              onTap: (){Navigator.of(context).pushNamed('/Add_Student');},
              child: Cards('assets/student.svg','Add Student'),
            ),

            GestureDetector(
              onTap: (){Navigator.of(context).pushNamed('/Add_Books');},
              child: Cards('assets/book.svg','Add Books'),
            ),

          ],
          ),
        ),
      );
  }
}