import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../Colors.dart';
import 'package:http/http.dart' as http;
import 'package:eacademia/Connection/conn.dart';
class FeeNotificationList extends StatefulWidget {
  const FeeNotificationList({Key? key}) : super(key: key);

  @override
  State<FeeNotificationList> createState() => _FeeNotificationListState();
}

class _FeeNotificationListState extends State<FeeNotificationList> {
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
    getFeeNotification();
  }
  bool loading =false;
  bool success = false;
  var fees =[];
  var batchName=[];
  getFeeNotification() async {
    var response;
    setState(() {
      loading = true;
    });
    try {
      setState(() {
        loading = true;
      });
      print(access_token);
      response = await http.get(
        Uri.parse("http://$host:8000/fee_notifications/"),
        headers: {
          'Authorization' : 'Bearer $access_token'
        },
      );
      var data = jsonDecode(response.body.toString());
      fees = data;
      print("checkpoint 1");
      var response2 = await http.get(
        Uri.parse("http://$host:8000/class/"),
        headers: {
          'Authorization' : 'Bearer $access_token'
        },
      );
      print("checkpoint 2");
      var data2 = jsonDecode(response2.body.toString());
      for(int i=0;i<data2.length;i++){
        print("checkpoint 3");
        print(fees);
        for(int j=0; j<fees.length;j++){
          if(fees[j]['grade'] == data2[i]['id']){
            setState(() {
              batchName.add(data2[i]['faculty']+"_"+data2[i]['year'].toString());
            });

          }
        }
      }

      print("The batch Name are");
      print(batchName);
      print("checkpoint 4");
      setState(() {
        loading = false;
        success = true;
      });
    }
    catch(e){

    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('E-ACADEMIA',style: TextStyle(fontFamily: 'Aerial',color: white),),
        backgroundColor: blue,
        elevation: 0,

      ),
      body:  RefreshIndicator(
        onRefresh: ()async{},
        child: ListView(
          children: [
            Container(
              color: lightBlue.withOpacity(0.2),
              child: Padding(
                padding: const EdgeInsets.fromLTRB(10,20,10,0),
                child: Container(
                  height: Get.height,
                  child:ListView.builder(
                      itemCount: fees.length,
                      itemBuilder: (BuildContext context, int index) {
                        return
                          Column(
                            children: [
                              Card(
                                child: ListTile(
                                  title: Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text("To:"+batchName[index],
                                        style: GoogleFonts.manrope(
                                            fontWeight: FontWeight.bold),),
                                      SizedBox(height: 8,),
                                      Text(
                                        " ${fees[index]['message'] }",
                                        style: GoogleFonts.manrope(
                                            color: grey1, fontSize: 14),),
                                      SizedBox(height: 8,),
                                      Text("3 days ago"),
                                      SizedBox(height: 8,),
                                    ],
                                  ),
                                  onTap: () {},

                                ),
                              ),
                              SizedBox(height: 20),
                            ],
                          );
                      }
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

