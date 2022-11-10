import 'package:flutter/material.dart';


Widget DefaultTextField(String hintText ,TextEditingController controller) =>

    Container(
      decoration: BoxDecoration(
        color: Colors.grey.shade200,
        border: Border.all(color: Colors.white),
        borderRadius: BorderRadius.circular(12),
      ),
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
          contentPadding: EdgeInsets.fromLTRB(10,0,0,0),
          border: InputBorder.none,
          hintText: hintText,

        ),
        ),
      );

Widget PasswordDefaultTextField(String hintText ,TextEditingController controller) =>

    Container(
      decoration: BoxDecoration(
        color: Colors.grey.shade200,
        border: Border.all(color: Colors.white,),
        borderRadius: BorderRadius.circular(12),
      ),
      child: TextField(
        obscureText: true,
        controller: controller,
        decoration: InputDecoration(
          contentPadding: EdgeInsets.fromLTRB(10,0,0,0),
          border: InputBorder.none,
          hintText: hintText,
          // suffixIcon: IconButton(
          //   icon: Icon(
          //     // Based on passwordVisible state choose the icon
          //     _passwordVisible
          //         ? Icons.visibility
          //         : Icons.visibility_off,
          //     color: Colors.grey,
          //   ),
          //   onPressed: () {
          //     // Update the state i.e. toogle the state of passwordVisible variable
          //     setState(() {
          //       _passwordVisible = !_passwordVisible;
          //     });
          //   },
          // ),

        ),
      ),
    );

