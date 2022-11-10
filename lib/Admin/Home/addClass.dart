import 'dart:ui';
import 'package:eacademia/Admin/AdminHome.dart';
import 'package:eacademia/AdminComponents/Cards.dart';
import 'package:eacademia/AdminComponents/Admin.dart';
import 'package:eacademia/AdminComponents/DefaultTextField.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../../Colors.dart';
import '../../Connection/conn.dart';
int getThisYear(){
  var now = new DateTime.now();
  var formatter = new DateFormat('yyyy');
  String formattedDate = formatter.format(now);
  return(int.parse(formattedDate));

}
final faculty=['BESE','BECE'];
int thisYear= getThisYear();
final year =[
  '${thisYear+1}','$thisYear','${thisYear-1}','${thisYear-2}','${thisYear-3}','${thisYear-4}',
  '${thisYear-5}',
];
// final year =['2023','2022','2021','2023','2023','2023','2023',];
class AddClass extends StatefulWidget {
  const AddClass({Key? key}) : super(key: key);

  @override
  State<AddClass> createState() => _AddClassState();
}

class _AddClassState extends State<AddClass> {
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
  String oneFaculty = faculty[0];
  String oneYear =year[0];
  CreateClass() async {
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
      response = await http.post(
        Uri.parse("http://$host:8000/class/"),
        headers: {
          'Authorization': 'Bearer $access_token',
        },
        body: {
          "faculty": oneFaculty,
          "year": oneYear
        },
      );
      print(response.body);
      setState(() {
        loading = false;
        success = true;
      });
    }
    catch(e){

    }
  }
  final _formkey = GlobalKey<FormState>();
  String? value = faculty[0];
  String? value2=year[0];
  _goToClassList(){
    Navigator.of(context).pushNamed('/Class_List');
  }

  String token ='';


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Class',style: TextStyle(fontFamily: 'Aerial',color: white),),
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
          child: Container(
            margin: const EdgeInsets.all(24),
            child: Form(
              key: _formkey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text('Faculty',style: TextStyle(fontSize: 16),),
                  SizedBox(height: 10,),
                  Container(
                    padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border.all(color: grey5),
                      borderRadius: BorderRadius.circular(5),
                    ),
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton<String>(
                          iconSize: 35,
                          icon: Icon(Icons.arrow_drop_down_sharp),
                          value: value,
                          isExpanded: true,
                          items: faculty.map(buildMenuItem).toList(),
                          onChanged: (value){ setState(() {
                            this.value=value;
                            oneFaculty= value!;
                          });}
                      ),
                    ),
                  ),
                  SizedBox(height: 15,),
                  Text('Year',style: TextStyle(fontSize: 16),),
                  SizedBox(height: 10,),
                  Container(
                    padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border.all(color: grey5),
                      borderRadius: BorderRadius.circular(5),
                    ),
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton<String>(
                          iconSize: 35,
                          icon: Icon(Icons.arrow_drop_down_sharp),
                          value: value2,
                          isExpanded: true,
                          items: year.map(buildMenuItem2).toList(),
                          onChanged: (value2){ setState(() {
                            this.value2=value2;
                            oneYear= value2!;
                          });}
                      ),
                    ),
                  ),
                  SizedBox(height: 10,),
                  success ? Text('Class Added Succesfully',style: TextStyle(fontSize: 16,color: green),):Container(),
                  SizedBox(height: 10,),
                  ElevatedButton(
                      onPressed: (){
                        CreateClass();
                      }, child: Padding(
                    padding: const EdgeInsets.all(4.0),
                    child:loading ? Padding(
                      padding: const EdgeInsets.fromLTRB(0,0,0,0),
                      child: SizedBox(
                          height: 15,
                          width: 15,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: white,
                          )),
                    ): Text('Create',style: TextStyle(fontSize: 18),),
                  )),
                  SizedBox(
                    height: 10,
                  ),
                  ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        primary: green,
                      ),
                      onPressed: (){ _goToClassList();},
                      child: Text("Show All Classes" ,style: TextStyle(fontSize: 16),)
                  ),


                ],
              ),
            ),
          ),
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
DropdownMenuItem<String> buildMenuItem2(String year){
  return DropdownMenuItem(
      value: year,
      child: Text(
        year,
      ));

}