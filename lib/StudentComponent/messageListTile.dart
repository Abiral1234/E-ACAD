import 'package:flutter/material.dart';

import '../Colors.dart';

Widget messageListTile(String message , String className , String time , bool isNew){
  return Card(
    child: ListTile(
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(message ),
          isNew ? Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              color: green,
            ),

            child: Padding(
              padding: const EdgeInsets.all(3.0),
              child: Text("New",style: TextStyle(color: Colors.white,fontSize: 12),),
            ),
          ) : Container(),
        ],
      ),
      subtitle: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text("Class:"+ className ,textAlign: TextAlign.start,style: TextStyle(fontSize: 12),),
          Text("Sent:"+time ,textAlign: TextAlign.end,style: TextStyle(fontSize: 12),),
        ],
      ),
    ),
  );
}