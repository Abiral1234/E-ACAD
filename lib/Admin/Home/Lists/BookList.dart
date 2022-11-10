import 'dart:convert';

import 'package:eacademia/Connection/conn.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../Colors.dart';
import 'package:http/http.dart'as http;

final faculty=[
  'BESE_2018',
  'BESE_2019',
  'BESE_2020',
  'BESE_2021',
  'BECE_2018',
  'BECE_2019',
  'BECE_2020',
  'BECE_2021',
];

class BookList extends StatefulWidget {
  const BookList({Key? key}) : super(key: key);

  @override
  State<BookList> createState() => _BookListState();
}

class _BookListState extends State<BookList> {
  // String? value = faculty[0];
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
    getBatches();
  }

  List classes=[];
  var batch_list=[
    'Select a batch',
  ];
  String value = 'Select a batch';

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
  bool loading =false;
  bool success = false;
  var books =[];
  String classId='';
  getBooks(String batchName) async {

    var response1;
    var response2;
    setState(() {
      books=[];
      loading = true;
    });
    try {
      setState(() {
        loading = true;
      });
      print(access_token);
      response1 = await http.get(
        Uri.parse("http://$host:8000/class/"),
        headers: {
          'Authorization' : 'Bearer $access_token'
        },
      );

      var data1 = jsonDecode(response1.body.toString());
      for(int i=0;i<data1.length;i++){
        if(batchName==data1[i]['faculty']+"_"+data1[i]['year']){
          classId = data1[i]['id'].toString();
        }
      }

      response2 = await http.get(
        Uri.parse("http://$host:8000/books/"),
        headers: {
          'Authorization' : 'Bearer $access_token'
        },
      );
      var data2 = jsonDecode(response2.body.toString());
      for(int i=0;i<data2.length;i++){
       if(data2[i]['grade'].toString()== classId){
         setState(() {
           books.add(data2[i]);
         });

       }
      }
      print(books.length);
      print(books[0]['name']);
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
      body: RefreshIndicator(
          onRefresh: ()async{

          },
        child: ListView(
          children:[
            Container(
            color: lightBlue.withOpacity(0.2),
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(10,20,10,0),
                  child: Container(
                    padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border.all(color: grey5),
                      borderRadius: BorderRadius.circular(5),
                    ),
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton<String>(
                          iconSize: 35,
                          icon: Icon(Icons.arrow_drop_down_sharp),
                          value: value,
                          isExpanded: true,
                          items: batch_list.map(buildMenuItem).toList(),
                          onChanged: (value){ setState(() {
                            this.value=value!;
                            getBooks(value);
                          });}
                      ),
                    ),
                  ),
                ),
                Padding(
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
                        1: FractionColumnWidth(0.5),
                        2: FractionColumnWidth(0.3),
                      },
                      children: [
                        buildRow(['No.', 'Book Name', 'Code Number'], isHeader: true),
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(10,0,10,0),
                  child: Container(
                    height: 1000,
                    child: ListView.builder(
                      itemCount: books.length,
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
                            1: FractionColumnWidth(0.5),
                            2: FractionColumnWidth(0.3),
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
                                  child: Text(books[index]['name']),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(books[index]['code_number']),
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
          ),],
        )

      ),
    );
  }
}
TableRow buildRow(List<String>cells , {bool isHeader =false} ){
  return TableRow(
    children: cells.map((cell) =>
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(cell,style: isHeader ?GoogleFonts.manrope(fontSize: 16,fontWeight: FontWeight.bold)   : GoogleFonts.manrope(fontSize: 16) ,
          ),
        )).toList(),
  );

}
DropdownMenuItem<String> buildMenuItem(String faculty){
  return DropdownMenuItem(
      value: faculty,
      child: Text(
        faculty,

      ));

}