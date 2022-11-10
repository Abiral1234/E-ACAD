import 'package:flutter/material.dart';

import '../Colors.dart';

Widget AssignmentListTile(String assignmentTitle ,String className , String deadline, bool isSubmitted){

  return Card(
    child: ListTile(
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(assignmentTitle,style: TextStyle(fontSize: 18),),
          isSubmitted ?
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              color: green,
            ),

            child: Padding(
              padding: const EdgeInsets.all(4.0),
              child: Text("Submitted",style: TextStyle(color: Colors.white,fontSize: 12),),
            ),
          ) :Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              color: red,
            ),

            child: Padding(
              padding: const EdgeInsets.all(4.0),
              child: Text("Not Submitted",style: TextStyle(color: Colors.white,fontSize: 12),),
            ),
          ),
        ],
      ),
      subtitle: Padding(
        padding: EdgeInsets.symmetric(vertical : 5),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text("Class: "+className,textAlign: TextAlign.start,style: TextStyle(fontSize: 12),),
            Text("Deadline :"+deadline,textAlign: TextAlign.end,style: TextStyle(fontSize: 12),),
          ],
        ),
      ),
    ),
  );
}