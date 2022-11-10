import 'dart:convert';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart'as http;
import '../AdminComponents/Admin.dart';
import '../Connection/conn.dart';
import '../Student/StudentHome.dart';
import '../StudentComponent/Student.dart';
import '../Teacher/Teacher.dart';
import '../Widget/DefaultTextField.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../Colors.dart';
class LogIn extends StatefulWidget {
  const LogIn({Key? key}) : super(key: key);

  @override
  State<LogIn> createState() => _LogInState();
}

class _LogInState extends State<LogIn> {
  String error=" ";
  String role="";
  bool loading= false;
  bool _passwordVisible = false ;
  final sliderController = CarouselController();
  int activeIndex=0;
  TextEditingController email = new TextEditingController();
  TextEditingController password = new TextEditingController();
  final Images=[
    'assets/login/Student.png',
    'assets/login/Teacher.png',
    'assets/login/Admin.png',
  ];

  String emailError ='';
  String passwordError='';
  LogIn()async{
    try{

      setState(() {
        loading = true;
      });
      print("email is "+ email.text);
      var response;
      response = await http.post(
          Uri.parse("http://$host:8000/auth/login_user/"),
          body: {
            "email": email.text,
            "password": password.text,
          }
      );
      setState(() {
        loading = false;
      });
      print(response.body);
      var data = jsonDecode(response.body.toString());
      print(data);
      print(response.statusCode);
      if(response.statusCode == 200){
        final SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
        sharedPreferences.setString('email', email.text);
        sharedPreferences.setString('password',  password.text);
        sharedPreferences.setString('refresh_token', data['tokens ']["refresh"]);
        sharedPreferences.setString('access_token', data['tokens ']["access"]);
        sharedPreferences.setString('user_role', data['user_role']);
        sharedPreferences.setString('user_id', data['user_id'].toString());
        String? userRole = sharedPreferences.getString("user_role");
        String? userId = sharedPreferences.getString("user_id");
        if(userRole == "superuser"){
          Get.offAll(Admin());
        }
        if(userRole == "teacher"){
          Get.offAll(Teacher());
        }
        if(userRole == "student"){
          Get.offAll(Student());
        }
      }
      if(response.statusCode == 400){
        if(data['email']!=null){
          setState(() {
            emailError = data['email'][0];
          });
        }
        else{
          setState(() {
            emailError='';
          });
        }
        if(data['password']!=null){
          setState(() {
            passwordError= data['password'][0];
          });
        }
        else{
          setState(() {
            passwordError= '';
          });
        }
        if(data['email']==null && data['password'] == null){
          setState(() {
            error = "Incorrect username or password";
          });
        }
      }

    }
    catch(e){
      print(e);
    }
  }

  List<bool> isSelected = [true, false, false];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:lightBlue,
      //activeIndex==0 ? Colors.grey.shade300 : activeIndex==1 ? lightBlue : Colors.greenAccent.shade100 ,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(15.0),
            child: Center(
              child: Column(
                children: [
                  SizedBox(height: 100,),
                  // CarouselSlider.builder(
                  //   carouselController: sliderController,
                  //     options: CarouselOptions(
                  //         height: 150,
                  //     onPageChanged: (newIndex,reason){
                  //       setState(() {
                  //         activeIndex =newIndex;
                  //         for(int index=0; index< isSelected.length ;index++){
                  //           if(index == newIndex){
                  //             isSelected[index] =true;
                  //           }
                  //           else{
                  //             isSelected[index] =false;
                  //           }
                  //         }
                  //       });
                  //     }),
                  //     itemCount: 3,
                  //     itemBuilder: (context,index,realIndex){
                  //       final Image = Images[index];
                  //       return buildImage(Image,index);
                  //     },
                  // ),
                  // SizedBox(height: 50,),
                  Align(
                    alignment: Alignment.topLeft,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        "Hello Again!",
                        // "Login",
                        style: GoogleFonts.bebasNeue(
                          fontSize: 52
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Text(
                    "Welcome! You've been missed",
                    style: TextStyle(
                      fontSize: 24,
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  // Container(
                  //   height: 50,
                  //   decoration: BoxDecoration(
                  //     color: Colors.white,
                  //     border: Border.all(color: Colors.white),
                  //     borderRadius: BorderRadius.circular(12),
                  //   ),
                  //   child: Row(
                  //     mainAxisAlignment: MainAxisAlignment.spaceAround,
                  //     children: [
                  //       ToggleButtons(
                  //         isSelected: isSelected,
                  //           children: [
                  //         Padding(
                  //           padding: const EdgeInsets.symmetric(horizontal: 35.0),
                  //           child: Text("Student"),
                  //         ),
                  //             Padding(
                  //               padding: const EdgeInsets.symmetric(horizontal: 35.0),
                  //               child: Text("Teacher"),
                  //             ),
                  //             Padding(
                  //               padding: const EdgeInsets.symmetric(horizontal: 35.0),
                  //               child: Text("Admin"),
                  //             ),
                  //       ],
                  //       onPressed:(int newIndex){
                  //           setState(() {
                  //             for(int index=0; index< isSelected.length ;index++){
                  //               if(index == newIndex){
                  //                 isSelected[index] =true;
                  //                 sliderController.jumpToPage(index);
                  //               }
                  //               else{
                  //                 isSelected[index] =false;
                  //               }
                  //             }
                  //           });
                  //       },
                  //         color: Colors.black,
                  //         selectedColor: Colors.white,
                  //         splashColor: green,
                  //         fillColor: green,
                  //         borderColor: Colors.white,
                  //         borderRadius: BorderRadius.horizontal(
                  //             left: Radius.circular(12),
                  //         right:Radius.circular(12), ),
                  //       ),
                  //
                  //     ],
                  //   ),
                  //
                  // ),
                  SizedBox(
                    height: 10,
                  ),
                  DefaultTextField("Enter your email",email),
                  SizedBox(
                    height: 5,
                  ),
                  emailError == null ? Container() :
                  Align(
                    alignment: Alignment.topLeft,
                    child: Text(

                      emailError,style:
                    GoogleFonts.manrope(
                         color: Colors.red ,fontWeight: FontWeight.bold
                    ),),
                  ),
                  SizedBox(
                    height: 5,
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
                    height: 5,
                  ),
                  passwordError == null ? Container() :
                  Align(
                    alignment: Alignment.topLeft,
                    child: Text(
                      passwordError,style:
                    GoogleFonts.manrope(
                        color: Colors.red ,fontWeight: FontWeight.bold
                    ),),
                  ),

                  error == null ? Container() :
                  Align(
                    alignment: Alignment.topLeft,
                    child: Text(
                      error,style:
                    GoogleFonts.manrope(
                        color: Colors.red ,fontWeight: FontWeight.bold
                    ),),
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  // Padding(
                  //   padding: const EdgeInsets.only(left: 10),
                  //   child: Align(
                  //     alignment: Alignment.bottomLeft,
                  //     child: Text(error,
                  //       style: TextStyle(
                  //         color: Colors.red,
                  //         fontWeight: FontWeight.w500,
                  //         fontSize: 15,
                  //       ),),
                  //   ),
                  // ),
                  // SizedBox(
                  //   height: 10,
                  // ),
                  GestureDetector(
                    onTap: (){LogIn();},
                    child: Container(
                      height: 50,
                      decoration: BoxDecoration(
                        color: blue,
                        border: Border.all(color: Colors.grey.shade300),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Center(
                        child:loading ? Padding(
                          padding: const EdgeInsets.fromLTRB(0,0,20,0),
                          child: SizedBox(
                              height: 20,
                              width: 20,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: white,
                              )),
                        ):Text("Login",
                            style: GoogleFonts.manrope(
                                fontWeight: FontWeight.bold,
                                color: Colors.white
                            )),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 25,
                  ),
                  // Row(
                  //   mainAxisAlignment: MainAxisAlignment.center,
                  //   children: [
                  //     Text("Not a member? ",
                  //       style: TextStyle(
                  //         fontWeight: FontWeight.w500,
                  //         fontSize: 15,
                  //       ),),
                  //     Text("Register Now",
                  //       style: TextStyle(
                  //         color: blue,
                  //         fontWeight: FontWeight.bold,
                  //         fontSize: 15,
                  //       ),),
                  //   ],
                  // )

                ],

              ),
            ),
          ),
        ),
      )
    );
  }
}

Widget buildImage(String image , int index) {
  return Container(
    child: Column(
      children: [
        Container(
          height: 100,
            child: Image.asset(image)),
        SizedBox(height: 10,),
        Text(index==0 ?"Student": index==1?"Teacher":"Admin",
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w400,
          ),),
      ],
    )

  );
}