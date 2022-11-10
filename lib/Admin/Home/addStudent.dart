import 'dart:convert';
import 'dart:ui';
import 'package:eacademia/Admin/AdminHome.dart';
import 'package:eacademia/AdminComponents/Cards.dart';
import 'package:eacademia/AdminComponents/Admin.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart'as http;
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../Colors.dart';
import 'package:eacademia/Connection/conn.dart';

import '../../Teacher/Teacher.dart';

class AddStudent extends StatefulWidget {
  const AddStudent({Key? key}) : super(key: key);

  @override
  State<AddStudent> createState() => _AddStudentState();
}

class _AddStudentState extends State<AddStudent> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('E-ACADEMIA',style: TextStyle(fontFamily: 'Aerial',color: white),),
        backgroundColor: blue,
        elevation: 0,
        leading: BackButton(onPressed: (){Get.offAll(Admin());},),

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
          child: AddStudentForm(),
        ),
      ),
    );
  }
}
class AddStudentForm extends StatefulWidget {
  const AddStudentForm({Key? key}) : super(key: key);

  @override
  State<AddStudentForm> createState() => _AddStudentFormState();
}

class _AddStudentFormState extends State<AddStudentForm> {

  final _formkey = GlobalKey<FormState>();
  _goToStudentList(){
    Navigator.of(context).pushNamed('/Student_List');
  }

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
    getBatches();
  }
  bool loading =false;
  bool success = false;

  List classes=[];
  getBatches() async{
    var response;
    setState(() {
      loading = true;
    });
    try {
      setState(() {
        loading = true;
      });
      print("The access token is");
      print(access_token);
      response = await http.get(
        Uri.parse("http://$host:8000/class/"),
        headers: {
          'Authorization': 'Bearer $access_token',
        },
      );
      print(response.body);
      print(response.statusCode);
      if(response.statusCode == 200){
        var data = jsonDecode(response.body.toString());
        classes=data;
        for(int i=2 ; i<classes.length;i++){
          String batchName = data[i]['faculty']+ "_" +data[i]['year'];
          batch_list.add(batchName);
        }

        setState(() {
          loading = false;
        });
      }

    }
    catch(e){
      print(e);
    }
  }
  createStudent() async {
    var response;
    setState(() {
      loading = true;
    });
    try {
      setState(() {
        loading = true;
      });
      print("The access Token is ");
      print(access_token);
      var data =  {
        "user": {
          "email": email.text,
          "password": password.text
        },
        "full_name" : fullName.text,
        "contact" : contact.text,
        "registration_number": regNum.text,
        "batch_name": value,
        "dob": dob
      };
      response = await http.post(
        Uri.parse("http://$host:8000/auth/student/"),
        headers: {
          'content-type': 'application/json',
          'Authorization': 'Bearer $access_token',
        },
        body:jsonEncode(data),
      );
      print(response.body);
      print(response.statusCode);
      if(response.statusCode == 201){
        setState(() {
          loading = false;
          success = true;
        });
      }

    }
    catch(e){
      print(e);
    }
  }
  TextEditingController fullName = new TextEditingController();
  TextEditingController email = new TextEditingController();
  TextEditingController password = new TextEditingController();
  TextEditingController regNum = new TextEditingController();
  TextEditingController batch = new TextEditingController();
  TextEditingController contact = new TextEditingController();
  String dob = DateFormat('yyyy-MM-dd').format(DateTime.now());
  var batch_list=[
    'Select a batch',
  ];
  String value = 'Select a batch';


  @override
  Widget build(BuildContext context) {
    // value = batch_list[0];
    return SingleChildScrollView(
      child: Container(
        margin: const EdgeInsets.all(24),
        child: Form(
          key: _formkey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text('Student Full Name',style: TextStyle(fontSize: 16),),
              SizedBox(height: 10,),
              DefaultTextField('Student Full Name',fullName),
              SizedBox(height: 15,),
              Text('Student Email',style: TextStyle(fontSize: 16),),
              SizedBox(height: 10,),
              DefaultTextField('Student Email',email),
              SizedBox(height: 15,),
              Text('Student Password',style: TextStyle(fontSize: 16),),
              SizedBox(height: 10,),
              DefaultTextField('Student Password',password),
              SizedBox(height: 15,),
              Text('Registration Number',style: TextStyle(fontSize: 16),),
              SizedBox(height: 10,),
              DefaultTextField('Registration Number',regNum),
              SizedBox(height: 15,),
              Text('Batch Name',style: TextStyle(fontSize: 16),),
              SizedBox(height: 10,),
              Container(
                padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
                decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(color: grey5),
                  borderRadius: BorderRadius.circular(0),
                ),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<String>(
                      iconSize: 35,
                      icon: Icon(Icons.arrow_drop_down_sharp),
                      value: value,
                      isExpanded: true,
                      items: batch_list.map(buildMenuItem).toList(),
                      onChanged: (value){ setState(() {
                        this.value=value!;
                      });}
                  ),
                ),
              ),
              SizedBox(height: 15,),
              Text('Contact Number',style: TextStyle(fontSize: 16),),
              SizedBox(height: 10,),
              DefaultTextField('Contact Number',contact),
              SizedBox(height: 15,),
              Text('D.O.B',style: TextStyle(fontSize: 16),),
              SizedBox(height: 10,),
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(color: grey5),
                  borderRadius: BorderRadius.circular(5),
                ),
                child: ListTile(
                  onTap: (){
                    showDatePicker(context: context,
                        initialDate: DateTime.now(),
                        firstDate: DateTime(1990),
                        lastDate: DateTime(2222)
                    ).then((date) {
                      setState(() {
                        dob = DateFormat('yyyy-MM-dd').format(date!);
                      });
                    });
                  },
                  title:Text(dob),
                  trailing: Icon(Icons.date_range),
                ),
              ),
              SizedBox(height: 10,),
              success ? Text('Student Added Succesfully',style: TextStyle(fontSize: 16,color: green),):Container(),
              SizedBox(height: 10,),
              ElevatedButton(onPressed: (){
                createStudent();
              }, child: Padding(
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
                  onPressed: (){ _goToStudentList();},
                  child: Text("Show Students" ,style: TextStyle(fontSize: 16),)
              ),
              SizedBox(height: 15,),
              Divider(),
              SizedBox(height: 10,),
              Center(
                child: Text('OR',style: TextStyle(fontSize: 18),),
              ),
              SizedBox(height: 10,),
              Center(
                child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      primary: blue,

                    ),
                    onPressed: (){ },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Padding(
                          padding: const EdgeInsets.fromLTRB(0,0,10,0),
                          child: Icon(Icons.insert_drive_file_rounded),
                        ),
                        Text("Upload Via CSV file" ,style: TextStyle(fontSize: 16),),
                      ],
                    )
                ),
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
DropdownMenuItem<String> buildMenuItem(String batch){
  return DropdownMenuItem(
      value: batch,
      child: Text(
        batch,
      ));

}