
import 'dart:convert';
import 'dart:io';
import 'dart:ui';
import 'package:eacademia/Admin/AdminHome.dart';
import 'package:eacademia/AdminComponents/Cards.dart';
import 'package:eacademia/AdminComponents/Admin.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../../Colors.dart';
import '../../AdminComponents/DefaultTextField.dart';
import 'package:eacademia/Connection/conn.dart';

class AddTeacher extends StatefulWidget {
  const AddTeacher({Key? key}) : super(key: key);

  @override
  State<AddTeacher> createState() => _AddTeacherState();
}

class _AddTeacherState extends State<AddTeacher> {



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('E-ACADEMIA',style: TextStyle(fontFamily: 'Aerial',color: white),),
        backgroundColor: blue,
        elevation: 0,
      ),
      body: Container(
        color: lightBlue.withOpacity(0.2),
        width: double.infinity,
        height: double.infinity,
        child: BackdropFilter(
          filter: ImageFilter.blur(
            sigmaX: 5.0,
            sigmaY: 5.0,
          ),
          child: AddTeacherForm(),
        ),
      ),
    );
  }
}
class AddTeacherForm extends StatefulWidget {
  const AddTeacherForm({Key? key}) : super(key: key);

  @override
  State<AddTeacherForm> createState() => _AddTeacherFormState();
}

class _AddTeacherFormState extends State<AddTeacherForm> {
  _goToTeacherList(){
    Navigator.of(context).pushNamed('/Teacher_List');
  }
TextEditingController nameController = new TextEditingController();
  TextEditingController emailController = new TextEditingController();
  TextEditingController passwordController = new TextEditingController();
  TextEditingController contactController = new TextEditingController();

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

  }

  bool loading =false;
  bool success = false;
  String token ='';
  createTeacher() async {
    var response;
    setState(() {
      loading = true;
    });
    try {
      setState(() {
        loading = true;
      });
      var data = {
        "user":{
          "email":emailController.text,
          "password":passwordController.text
        },
        "full_name":nameController.text,
        "contact":contactController.text
      };
      //Map<String, String> headers = {HttpHeaders.contentTypeHeader: "application/json",'Authorization': 'Bearer $access_token'};
      response = await http.post(
        Uri.parse("http://$host:8000/auth/teacher/"),
          headers: {
            'content-type': 'application/json',
            'Authorization': 'Bearer $access_token',
          },
        body:  jsonEncode(data)
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

  final _formkey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        margin: const EdgeInsets.all(24),
        child: Form(
          key: _formkey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text('Teacher Name',style: TextStyle(fontSize: 16),),
              SizedBox(height: 10,),
              DefaultTextField('Teacher Name',nameController),
              SizedBox(height: 15,),
              Text('Teacher Email',style: TextStyle(fontSize: 16),),
              SizedBox(height: 10,),
              DefaultTextField('Teacher Email',emailController),
              SizedBox(height: 15,),
              Text('Password',style: TextStyle(fontSize: 16),),
              SizedBox(height: 10,),
              DefaultTextField('Password',passwordController),
              SizedBox(height: 15,),
              Text('Contact Number',style: TextStyle(fontSize: 16),),
              SizedBox(height: 10,),
              DefaultTextField('Contact Number',contactController),
              SizedBox(height: 10,),
              success ? Text('Teacher Added Succesfully',style: TextStyle(fontSize: 16,color: green),):Container(),
              SizedBox(height: 10,),
              ElevatedButton(onPressed: (){
                createTeacher();
                },
                  child: Padding(
                    padding: const EdgeInsets.all(4.0),
                    child: loading ? Padding(
                      padding: const EdgeInsets.fromLTRB(0,0,0,0),
                      child: SizedBox(
                          height: 15,
                          width: 15,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: white,
                          )),
                    ): Text('Submit',style: TextStyle(fontSize: 18),),
              )),
              SizedBox(
                height: 10,
              ),
              ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    primary: green,
                  ),
                  onPressed: (){ _goToTeacherList();},
                  child: Text("Show All Teacher" ,style: TextStyle(fontSize: 16),)
              ),
            ],
          ),
        ),
      ),
    );
  }


}

Widget DefaultTextField(String hintText, TextEditingController controller){
  return Container(
    decoration: BoxDecoration(
      color: Colors.white,
      border: Border.all(color: grey5),
      borderRadius: BorderRadius.circular(5),
    ),
    child: TextField(
      controller: controller,
      decoration: InputDecoration(
        contentPadding: EdgeInsets.fromLTRB(10,0,0,0),
        border: InputBorder.none,
        fillColor: Colors.white,
        hintText: hintText,
        hintStyle: TextStyle(color: grey3),
      ),
    ),
  );
}
