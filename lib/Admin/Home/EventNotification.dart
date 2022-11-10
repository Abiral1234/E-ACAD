import 'dart:convert';

import 'package:flutter/material.dart';
// import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../../Colors.dart';
import 'package:eacademia/Connection/conn.dart';

import '../../Services/noti.dart';
// final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

class EventNotification extends StatefulWidget {
  const EventNotification({Key? key}) : super(key: key);

  @override
  State<EventNotification> createState() => _EventNotificationState();
}

class _EventNotificationState extends State<EventNotification> {
  @override
  _goToEventNotificationList(){
    Navigator.of(context).pushNamed('/Show_Recent_Event_Notification');
  }
  @override
  // ignore: must_call_super
  void initState() {
    // Noti.initialize(flutterLocalNotificationsPlugin);
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
  String batchId ='';
  getClassId(String batchName)async{
    var response = await http.get(
      Uri.parse("http://$host:8000/class/"),
      headers: {
        'Authorization': 'Bearer $access_token',
      },
    );
    var data = jsonDecode(response.body.toString());

    for(int i=0 ; i<data.length;i++){
      if(batchName == data[i]['faculty']+ "_" +data[i]['year']){
        print("The selected batch id is");
        print(data[i]['id']);
        setState(() {
          batchId = data[i]['id'].toString();
        });
      }
    }
  }
  createEvent() async {
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
        Uri.parse("http://$host:8000/event_notifications/"),
        headers: {
          'Authorization': 'Bearer $access_token',
        },
        body: {
          "grade": batchId,
          "message": message.text,
        },
      );
      print(response.body);
      print(response.statusCode);
      if(response.statusCode == 201){
        // Noti.showBigTextNotification(
        //     title: "Event Notification",
        //     body: message.text,
        //     fln: flutterLocalNotificationsPlugin
        // );
      }
      setState(() {
        loading = false;
        success = true;
      });
    }
    catch(e){

    }
  }
  TextEditingController batchname = TextEditingController();
  TextEditingController message = TextEditingController();
  var batch_list=[
    'Select a batch',
  ];
  String value = 'Select a batch';
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Events',style: TextStyle(fontFamily: 'Aerial',color: white),),
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
              child: Text('Batch Name :',style: TextStyle(fontSize: 18),),
            ),
            SizedBox(
              height: 8,
            ),
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
                      this.value = value!;
                      getClassId(value);
                    });}
                ),
              ),
            ),
            SizedBox(
              height: 8,
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(5,0,0,0),
              child: Text('Message:',style: TextStyle(fontSize: 18),),
            ),
            SizedBox(
              height: 8,
            ),
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
                  contentPadding: EdgeInsets.fromLTRB(10,10,0,0),
                  border: InputBorder.none,
                  fillColor: Colors.white,
                  hintText: 'Message About Event....',
                  hintStyle: TextStyle(color: grey3),
                ),
              ),
            ),
            SizedBox(
              height: 10,
            ),
            success ? Text('Event Sent Succesfully',style: TextStyle(fontSize: 16,color: green),):Container(),
            SizedBox(height: 10,),
            ElevatedButton(onPressed: (){createEvent();},
                child: loading ? Padding(
                  padding: const EdgeInsets.fromLTRB(0,0,0,0),
                  child: SizedBox(
                      height: 15,
                      width: 15,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: white,
                      )),
                ):Text('Send Message')
            ),
            SizedBox(
              height: 10,
            ),
            ElevatedButton(
                style: ElevatedButton.styleFrom(
                  primary: green,
                ),
                onPressed: (){_goToEventNotificationList();},
                child: Text("Show Recently Sent Notification" ,style: TextStyle(fontSize: 16),)
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