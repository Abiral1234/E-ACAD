import 'dart:convert';
import 'package:eacademia/Connection/conn.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import '../../../Colors.dart';
import '../../../Connection/conn.dart';
class ClassList extends StatefulWidget {
  const ClassList({Key? key}) : super(key: key);
  @override
  State<ClassList> createState() => _ClassListState();
}
class _ClassListState extends State<ClassList> {
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
    getClass();
  }
  bool loading =false;
  bool success = false;
  var classes =[];
  getClass() async {
    var response;
    try {
      setState(() {
        loading = true;
      });
      print(access_token);
      response = await http.get(
        Uri.parse("http://$host:8000/class/"),
        headers: {
          'Authorization' : 'Bearer $access_token'
        },
      );
      print(response.body);
      var data = jsonDecode(response.body.toString());
      // classes = data;
      for(int i =2;i<data.length;i++){
        classes.add(data[i]);
      }
      print(classes.length);
      print(classes[0]['name']);
      setState(() {
        loading = false;
        success = true;
      });
    }
    catch(e){

    }
  }
  deleteClass(String ClassId) async {
    var response;
    setState(() {
      loading = true;
    });
    try {
      print("The selected Class Id is");
      print(ClassId);
      setState(() {
        loading = true;
      });
      response = await http.delete(
        Uri.parse("http://$host:8000/update_class/$ClassId/"),
        headers: {
          'Authorization' : 'Bearer $access_token'
        },
      );
      // var data = jsonDecode(response.body.toString());
      setState(() {
        getToken();
        loading = false;
        success = true;
      });
    }
    catch(e){
      print(e);
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
      body: RefreshIndicator(
        onRefresh: ()async{
           await getToken();
        },
        child: ListView(
          children :[
            Container(
            color: lightBlue.withOpacity(0.2),
            child: Padding(
              padding: const EdgeInsets.fromLTRB(10,20,10,0),
              child: Container(
                color: white,
                child: Table(
                  border: TableBorder.all(
                      color: grey4,
                    borderRadius: BorderRadius.circular(0),
                  ),
                  columnWidths: {
                    0: FractionColumnWidth(0.2),
                    1: FractionColumnWidth(0.4),
                    2: FractionColumnWidth(0.4),
                  },
                  children: [
                    buildRow(['No.','Class Name','Action'],isHeader: true),
                    // buildRow(['1','BESE_2018','Action']),
                    // buildRow(['2','BESE_2019','Action']),
                    // buildRow(['3','BECE_2018','Action']),
                  ],
                ),

              ),
            ),
          ),
            Padding(
              padding: const EdgeInsets.fromLTRB(10,0,10,0),
              child: Container(
                height: 1000,
                child: ListView.builder(
                    itemCount: classes.length,
                    itemBuilder: (BuildContext context, int index){
                      return Container(
                        color: white,
                        child: Table(
                          border: TableBorder.all(
                            color: grey4,
                            borderRadius: BorderRadius.circular(0),
                          ),
                          columnWidths: {
                            0: FractionColumnWidth(0.2),
                            1: FractionColumnWidth(0.4),
                            2: FractionColumnWidth(0.4),
                          },
                          children: [
                            TableRow(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text('${index+1}'),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text("${classes[index]["faculty"]}_${classes[index]["year"]}"),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Row(
                                      children: [
                                        //Icon(Icons.edit,color: green,),
                                        GestureDetector(
                                          onTap:(){
                                            print("Delete Function");
                                            print(classes[index]["id"]);
                                            deleteClass("${classes[index]["id"]}");
                                          },

                                          child: Padding(
                                            padding: const EdgeInsets.symmetric(horizontal: 10.0),
                                            child: Icon(Icons.delete,color: red,),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ]
                            )
                          ],
                        ),
                      );
                    }),
              ),
            ),
      ],
        ),
      ),
    );
  }
}
TableRow buildRow(List<String>cells , {bool isHeader =false} ){
  return TableRow(
    children: cells.map((cell) =>
        cell=="Action" && isHeader == false ?
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10.0),
          child: Row(
            children: [
              Icon(Icons.edit,color: green,),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10.0),
                child: Icon(Icons.delete,color: red,),
              ),
            ],
          ),
        ):
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(cell,style: isHeader ?GoogleFonts.manrope(fontSize: 16,fontWeight: FontWeight.bold)   : GoogleFonts.manrope(fontSize: 16) ,
          ),
        )
    ).toList(),
  );

}
