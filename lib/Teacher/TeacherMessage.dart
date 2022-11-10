import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../Colors.dart';
import '../TeacherComponents/DefaultTextField.dart';
import 'package:http/http.dart'as http;
import 'package:eacademia/Connection/conn.dart';
final faculties=[
  '-- SELECT YOUR CLASS --',
  'BESE_2015 (AOS)',
  'BESE_2016 (DSA)',
  'BESE_2017 (ADA)',
  'BESE_2018 (EE)',

];
class TeacherMessage extends StatefulWidget {
  const TeacherMessage({Key? key}) : super(key: key);

  @override
  State<TeacherMessage> createState() => _TeacherMessageState();
}

class _TeacherMessageState extends State<TeacherMessage> {
  String? value = faculties[0];
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

  SendMessageToAdmin()async {
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
        Uri.parse("http://$host:8000/create_feedback/"),
        headers: {
          'Authorization': 'Bearer $access_token',
        },
        body: {
          "subject": subject.text,
          "message": message.text,
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
  TextEditingController subject = new TextEditingController();
  TextEditingController message = new TextEditingController();



  @override
  Widget build(BuildContext context) {

    TextEditingController title = new TextEditingController();
    return SingleChildScrollView(
      child: Container(
        padding: EdgeInsets.fromLTRB(20, 30, 20, 20),
        color:  lightBlue.withOpacity(0.2),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children:  [
            Padding(
              padding: const EdgeInsets.fromLTRB(5,0,0,0),
              child: Text('Send Message To Admin',style: TextStyle(fontSize: 18,fontWeight: FontWeight.w400),),
            ),
            SizedBox(
              height: 10,
            ),

            DefaultTextField(hintText: 'Title',controller: subject,),
            SizedBox(height: 15,),
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border.all(color: grey5),
                borderRadius: BorderRadius.circular(5),

              ),
              child: TextFormField(
                controller: message,
                minLines: 5,
                maxLines: 10,
                decoration: InputDecoration(
                  contentPadding: EdgeInsets.fromLTRB(10,10,0,10),
                  border: InputBorder.none,
                  fillColor: Colors.white,
                  hintText: 'Message....',
                  hintStyle: TextStyle(color: grey3),
                ),
              ),
            ),
            SizedBox(
              height: 10,
            ),
            success ? Text('Message Sent Succesfully',style: TextStyle(fontSize: 16,color: green),):Container(),
            SizedBox(
              height: 10,
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                primary: blue,
              ),
                onPressed: (){SendMessageToAdmin();},
                child: loading ? Padding(
                  padding: const EdgeInsets.fromLTRB(0,0,0,0),
                  child: SizedBox(
                      height: 15,
                      width: 15,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: white,
                      )),
                ):Text('Submit',style: TextStyle(fontSize: 18),)
            ),

          ],
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