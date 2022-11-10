import 'package:eacademia/Settings/ChangePassword.dart';
import 'package:eacademia/Settings/PrivacyAndSecurity.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../Colors.dart';
import '../../Fonts.dart';
import '../../LogIn/LogIn.dart';
import '../../Settings/Language.dart';
import '../EditTeacherClass.dart';

class TeacherSettings extends StatefulWidget {
  const TeacherSettings({Key? key}) : super(key: key);

  @override
  State<TeacherSettings> createState() => _TeacherSettingsState();
}

class _TeacherSettingsState extends State<TeacherSettings> {
  @override
  bool switch1=true;
  bool switch2=true;
  bool switch3=true;
  bool switch4=true;


  Widget build(BuildContext context) {
    return Scaffold(

      body: Container(
        color: lightBlue.withOpacity(0.2),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(10,20,10,0),
          child: ListView(
            children:[
              Padding(
                padding: const EdgeInsets.fromLTRB(10, 0, 0, 20),
                child: Text("Settings",style: TextStyle(fontSize: 30,fontWeight: FontWeight.w500),),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(8.0,15,0,0),
                child: Row(
                  children: [
                    Icon(Icons.developer_board,size: 30,color: blue,),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(8,0,0,0),
                      child: Text("Class",style: TextStyle(fontSize: 20,fontWeight: FontWeight.w500),),
                    ),
                  ],
                ),
              ),
              Divider(),
              Card(
                child: ListTile(
                  title: Text("Edit Class",
                    style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: grey1
                    ),),
                  trailing: Icon(Icons.arrow_forward_ios),
                  onTap: (){Get.to(EditTeacherClass());},
                ),
              ),

              Padding(
                padding: const EdgeInsets.fromLTRB(8.0,15,0,0),
                child: Row(
                  children: [
                    Icon(Icons.account_circle_rounded,size: 30,color: blue,),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(8,0,0,0),
                      child: Text("Account",style: TextStyle(fontSize: 20,fontWeight: FontWeight.w500),),
                    ),
                  ],
                ),
              ),
              Divider(),

              Card(
                child: ListTile(
                  title: Text("Change Password",
                    style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: grey1
                    ),),
                  trailing: Icon(Icons.arrow_forward_ios),
                  onTap: (){Get.to(ChangePassword());},
                ),
              ),

              Card(
                child: ListTile(
                  title: Text("Language",
                    style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: grey1
                    ),),
                  trailing: Icon(Icons.arrow_forward_ios),
                  onTap: (){Get.to(Language());},
                ),
              ),
              Card(
                child: ListTile(
                  title: Text("About",
                    style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: grey1
                    ),),
                  trailing: Icon(Icons.arrow_forward_ios),
                  onTap: (){Get.to(PrivacyAndSecurity());},
                ),
              ),
              Card(
                child: ListTile(

                  title: Text("Sign Out",
                    style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: grey1
                    ),),
                  trailing: Icon(Icons.arrow_forward_ios),
                  onTap: ()async{
                    final SharedPreferences sharedPreferences =await SharedPreferences.getInstance();
                    sharedPreferences.setString("user_role", "null");
                    Get.offAll(LogIn());
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
