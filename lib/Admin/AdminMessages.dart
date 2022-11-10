import 'package:flutter/material.dart';

import '../Colors.dart';
import '../AdminComponents/Cards.dart';
import 'package:http/http.dart' as http;
import 'package:eacademia/Connection/conn.dart';
class AdminMessages extends StatefulWidget {
  const AdminMessages({Key? key}) : super(key: key);

  @override
  State<AdminMessages> createState() => _AdminMessagesState();
}

class _AdminMessagesState extends State<AdminMessages> {
  @override

  Widget build(BuildContext context) {
    return Container(
      color: lightBlue.withOpacity(0.2),
      width: double.infinity,
      height: double.infinity,
      child: Wrap(
        alignment: WrapAlignment.start,
        children: [
          GestureDetector(
            onTap: (){Navigator.of(context).pushNamed('/Fee_Notification');},
            child:Cards('assets/fee.svg','Fee Notification'),
          ),
          GestureDetector(
            onTap: (){Navigator.of(context).pushNamed('/Event_Notification');},

            child : Cards('assets/notification.svg','Event Notification'),
          ),
        ],
      ),
    );
  }
}
