import 'dart:convert';

import 'package:eacademia/Settings/PrivacyAndSecurity.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../Colors.dart';
import 'package:eacademia/Connection/conn.dart';

import '../Settings/ChangePassword.dart';
import '../Settings/Language.dart';
import 'package:http/http.dart' as http;

class AdminSetting extends StatefulWidget {
  const AdminSetting({Key? key}) : super(key: key);

  @override
  State<AdminSetting> createState() => _AdminSettingState();
}

class _AdminSettingState extends State<AdminSetting> {
  @override
  bool switch1=true;
  bool switch3=true;
  bool switch4=true;

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
    getSettings();
  }
  bool loading =false;
  bool success = false;

  getSettings()async {
    var response;
    try {
      setState(() {
        loading = true;
      });
      response = await http.get(
        Uri.parse("http://$host:8000/create_settings/"),
        headers: {
          'Authorization': 'Bearer $access_token',
        },
      );
      var data = jsonDecode(response.body.toString());
      // int lastIndex;
      setState(() {
        // lastIndex= data.length-1;
        // print("The last index is");
        // print(lastIndex);
        switch1=data[0]["number_of_batches_boolean"];
        switch4=data[0] ["number_of_books_boolean"];
        switch3=data[0]["number_of_teachers_boolean"];
        loading = false;
      });
    }
    catch(e){
      print(e);
    }
  }
  createSettings() async {
    var response;
    setState(() {
      loading = true;
    });
    try {
      setState(() {
        loading = true;
      });
      response = await http.put(
        Uri.parse("http://$host:8000/create_settings/1/"),
        headers: {
          'Authorization' : 'Bearer $access_token'
        },
        body: {
          "number_of_batches_boolean": switch1.toString(),
          "number_of_books_boolean": switch4.toString(),
          "number_of_teachers_boolean": switch3.toString()
        },
      );
      print(response.body);
      setState(() {
        loading = false;
        success = true;
      });
    }
    catch(e){
        print(e);
    }
  }


  Widget build(BuildContext context) {
    return Container(
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
              padding: const EdgeInsets.fromLTRB(8.0,10,0,0),
              child: Row(
                children: [
                  Icon(Icons.widgets_sharp,size: 30,color: blue,),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(8,0,0,0),
                    child: Text("Database",style: TextStyle(fontSize: 20,fontWeight: FontWeight.w500),),
                  ),
                ],
              ),
            ),
            Divider(),
            Card(
              child: SwitchListTile(

                title: Text("Limit Number of Batches To 20",
                  style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: grey1
                  ),), value: switch1,
                onChanged: (value){
                  setState(() {
                    switch1 = !switch1;
                    createSettings();
                  });
                },

              ),
            ),
            Card(
              child: SwitchListTile(
                title: Text("Limit Number Of Teachers To 50",
                  style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: grey1
                  ),), value: switch3,
                onChanged: (value){
                  setState(() {
                    switch3 = !switch3;
                    createSettings();
                  });
                },

              ),
            ),
            Card(
              child: SwitchListTile(
                title: Text("Limit Number Of Books to 400",
                  style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: grey1
                  ),), value: switch4,
                onChanged: (value){
                  setState(() {
                    switch4 = !switch4;
                    createSettings();
                  });
                },

              ),
            ),
            // success ? Text('Settings Saved',style: TextStyle(fontSize: 16,color: green),):Container(),
            // SizedBox(height: 10,),
            // Container(
            //   height: 20,
            //   width: 20,
            //   child: ElevatedButton(
            //       onPressed: (){}, child: loading ? Padding(
            //     padding: const EdgeInsets.fromLTRB(0,0,0,0),
            //     child: SizedBox(
            //         height: 15,
            //         width: 15,
            //         child: CircularProgressIndicator(
            //           strokeWidth: 2,
            //           color: white,
            //         )),
            //   ):
            //   Padding(
            //     padding: const EdgeInsets.all(4.0),
            //     child: Text('Submit',style: TextStyle(fontSize: 18),),
            //   )),
            // ),
            //
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
                  Navigator.pushNamed(context, '/Login');
                },
              ),
            ),
        ],
        ),
      ),
    );
  }
}
