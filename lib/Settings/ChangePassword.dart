import 'dart:convert';

import 'package:eacademia/AdminComponents/DefaultTextField.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../Colors.dart';
import 'package:http/http.dart' as http;
import 'package:eacademia/Connection/conn.dart';

class ChangePassword extends StatefulWidget {
  const ChangePassword({Key? key}) : super(key: key);

  @override
  State<ChangePassword> createState() => _ChangePasswordState();
}

class _ChangePasswordState extends State<ChangePassword> {
  
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
      oldPassword = sharedPreferences.get('password').toString();
      refresh_token = sharedPreferences.get('refresh_token').toString();
      access_token = sharedPreferences.get('access_token').toString();
    });
    print("The old password is"+oldPassword);

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
        for(int i=0 ; i<classes.length;i++){
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
  String oldPassword='';
  createChangePassword() async {
    var response;
    setState(() {
      loading = true;
    });
    try {
      setState(() {
        loading = true;
      });

      response = await http.post(
        Uri.parse("http://$host:8000/auth/change_password/"),
        headers: {
          'Authorization': 'Bearer $access_token',
        },
        body: {
          "old_password": oldPassword,
          "new_password": password.text,
          "confirm_password":confirmPassword.text
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
  TextEditingController batchname = TextEditingController();
  TextEditingController message = TextEditingController();
  var batch_list=[
    'Select a batch',
  ];
  String value = 'Select a batch';
  bool _passwordVisible = false ;
  bool _confirmPasswordVisible = false ;
  TextEditingController password = new TextEditingController();
  TextEditingController confirmPassword = new TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Change Password',style: TextStyle(fontFamily: 'Aerial',color: white),),
        backgroundColor:blue,
        elevation: 0,
      ),
      body: Container(
        padding: EdgeInsets.fromLTRB(20, 30, 20, 20),
        color:  lightBlue.withOpacity(0.2),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children:  [
            Padding(
              padding: const EdgeInsets.fromLTRB(5,0,0,0),
              child: Text('New Password:',style: TextStyle(fontSize: 18),),
            ),
            SizedBox(
              height: 8,
            ),
            Container(
              decoration: BoxDecoration(
                color: Colors.grey.shade200,
                border: Border.all(color: Colors.white,),
                borderRadius: BorderRadius.circular(12),
              ),
              child: TextFormField(
                obscureText:  !_passwordVisible,
                controller: password,
                decoration: InputDecoration(
                  contentPadding: EdgeInsets.fromLTRB(10,12,0,0),
                  border: InputBorder.none,
                  hintText: "Enter your password",
                  suffixIcon: IconButton(
                    icon: Icon(
                      // Based on passwordVisible state choose the icon
                      _passwordVisible
                          ? Icons.visibility
                          : Icons.visibility_off,
                      color: Colors.grey,
                    ),
                    onPressed: () {
                      // Update the state i.e. toogle the state of passwordVisible variable
                      setState(() {
                        _passwordVisible = !_passwordVisible;
                      });
                    },
                  ),

                ),
              ),
            ),
            SizedBox(
              height: 8,
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(5,0,0,0),
              child: Text('Confirm new password:',style: TextStyle(fontSize: 18),),
            ),
            SizedBox(
              height: 8,
            ),
            Container(
              decoration: BoxDecoration(
                color: Colors.grey.shade200,
                border: Border.all(color: Colors.white,),
                borderRadius: BorderRadius.circular(12),
              ),
              child: TextFormField(
                obscureText:  !_confirmPasswordVisible,
                controller: confirmPassword,
                decoration: InputDecoration(
                  contentPadding: EdgeInsets.fromLTRB(10,12,0,0),
                  border: InputBorder.none,
                  hintText: "Confirm new password:",
                  suffixIcon: IconButton(
                    icon: Icon(
                      // Based on passwordVisible state choose the icon
                      _confirmPasswordVisible
                          ? Icons.visibility
                          : Icons.visibility_off,
                      color: Colors.grey,
                    ),
                    onPressed: () {
                      // Update the state i.e. toogle the state of passwordVisible variable
                      setState(() {
                        _confirmPasswordVisible = !_confirmPasswordVisible;
                      });
                    },
                  ),

                ),
              ),
            ),
            SizedBox(
              height: 10,
            ),
            success ? Text('Password Changed Successfully',style: TextStyle(fontSize: 16,color: green),):Container(),
            SizedBox(height: 10,),
            ElevatedButton(onPressed: (){
              createChangePassword();
            },
                child: loading ? Padding(
                  padding: const EdgeInsets.fromLTRB(0,0,0,0),
                  child: SizedBox(
                      height: 15,
                      width: 15,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: white,
                      )),
                ):Text('Submit')
            ),
            SizedBox(
              height: 10,
            ),

          ],
        ),
      ),
    );
  }
}
DropdownMenuItem<String> buildMenuItem(String batch){
  return DropdownMenuItem(
      value: batch,
      child: Text(
        batch,
      ));

}