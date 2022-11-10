import 'package:flutter/material.dart';

import '../Colors.dart';
class DefaultTextField extends StatefulWidget {
  String hintText;
  TextEditingController controller;
   DefaultTextField({Key? key ,required this.hintText,required this.controller}) : super(key: key);

  @override
  State<DefaultTextField> createState() => _DefaultTextFieldState();
}

class _DefaultTextFieldState extends State<DefaultTextField> {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: grey5),
        borderRadius: BorderRadius.circular(5),
      ),
      child: TextField(
        controller: widget.controller,
        decoration: InputDecoration(
          contentPadding: EdgeInsets.fromLTRB(10,0,0,0),
          border: InputBorder.none,
          fillColor: Colors.white,
          hintText: widget.hintText,
          hintStyle: TextStyle(color: grey3),
        ),
      ),
    );
  }
}
