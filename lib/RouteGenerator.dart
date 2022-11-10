import 'package:eacademia/Admin/AdminHome.dart';
import 'package:eacademia/Admin/Home/addBooks.dart';
import 'package:eacademia/Admin/Home/addStudent.dart';
import 'package:eacademia/Admin/Home/addTeacher.dart';
import 'package:eacademia/AdminComponents/Admin.dart';
import 'package:eacademia/SplashScreen.dart';
import 'package:eacademia/Teacher/ClassPages/ClassMessage.dart';
import 'package:eacademia/Teacher/TeacherMessage.dart';
import 'package:flutter/material.dart';
import 'Admin/Home/EventNotification.dart';
import 'Admin/Home/FeeNotification.dart';
import 'Admin/Home/Lists/BookList.dart';
import 'Admin/Home/Lists/ClassList.dart';
import 'Admin/Home/Lists/EventNotificationList.dart';
import 'Admin/Home/Lists/FeeNotificationList.dart';
import 'Admin/Home/Lists/StudentList.dart';
import 'Admin/Home/Lists/TeacherList.dart';
import 'Admin/Home/addClass.dart';
import 'ChooseView.dart';
import 'LogIn/LogIn.dart';
import 'Student/ClassPages/StudentClassHomePage.dart';
import 'Student/StudentHome.dart';
import 'StudentComponent/Student.dart';
import 'Teacher/AppBarActions/TeacherSettings.dart';
import 'Teacher/ClassPages/ClassHomePage.dart';
import 'Teacher/ClassPages/CreateAssignmentPage.dart';
import 'Teacher/ClassPages/SubmitNotePage.dart';
import 'Teacher/Teacher.dart';
import 'Teacher/TeacherHome.dart';
import 'main.dart';

class RouteGenerator {
  static Route<dynamic>? generateRoute(RouteSettings settings) {
    final args = settings.arguments;

    switch (settings.name) {
      case'/':
        return MaterialPageRoute(
            builder: (_) =>SplashScreen()
        );

      case '/Login':
        return MaterialPageRoute(
            builder: (_) => LogIn()
        );


    //-------------------ADMIN----------------//
      case '/Admin':
        return MaterialPageRoute(
            builder: (_) => Admin()
        );
      case '/Add_Class':
        return MaterialPageRoute(
            builder: (_) => AddClass()
        );
      case '/Class_List':
        return MaterialPageRoute(
            builder: (_) => ClassList()
        );
      case '/Student_List':
        return MaterialPageRoute(
            builder: (_) => StudentList()
        );
      case '/Add_Student':
        return MaterialPageRoute(
            builder: (_) => AddStudent()
        );
      case '/Add_Teacher':
        return MaterialPageRoute(
            builder: (_) => AddTeacher()
        );
      case '/Teacher_List':
        return MaterialPageRoute(
            builder: (_) => TeacherList()
        );
      case '/Add_Books':
        return MaterialPageRoute(
            builder: (_) => AddBooks()
        );
      case '/Book_List':
        return MaterialPageRoute(
            builder: (_) => BookList()
        );
      case '/Fee_Notification':
        return MaterialPageRoute(
            builder: (_) => FeeNotification()
        );
      case '/Show_Recent_Notification':
        return MaterialPageRoute(
            builder: (_) => FeeNotificationList()
        );
      case '/Event_Notification':
        return MaterialPageRoute(
            builder: (_) => EventNotification()
        );
      case '/Show_Recent_Event_Notification':
        return MaterialPageRoute(
            builder: (_) => EventNotificationList()
        );

    //-------------------TEACHER----------------//
      case '/Teacher':
        return MaterialPageRoute(
            builder: (_) => Teacher()
        );
      case '/TeacherSettings':
        return MaterialPageRoute(
            builder: (_) => TeacherSettings()
        );




    //-------------------Student----------------//
      case '/Student':
        return MaterialPageRoute(
            builder: (_) => Student()
        );





    }
  }

}

