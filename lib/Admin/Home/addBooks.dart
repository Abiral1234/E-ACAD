import 'dart:convert';
import 'dart:ui';
import 'package:eacademia/Admin/AdminHome.dart';
import 'package:eacademia/AdminComponents/Cards.dart';
import 'package:eacademia/AdminComponents/Admin.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart'as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../../Colors.dart';
import '../../Connection/conn.dart';


class AddBooks extends StatefulWidget {
  const AddBooks({Key? key}) : super(key: key);

  @override
  State<AddBooks> createState() => _AddBooksState();
}

class _AddBooksState extends State<AddBooks> {

  TextEditingController bookName =TextEditingController();
  TextEditingController batch =TextEditingController();
  TextEditingController codeNumber =TextEditingController();
  _goToBookList(){
    Navigator.of(context).pushNamed('/Book_List');
  }
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
  bool loading =false;
  bool success = false;

  List classes=[];
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

  createBook() async {
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
      print('authorization');
      response = await http.post(
        Uri.parse("http://$host:8000/books/"),
        headers: {
          'Authorization' : 'Bearer $access_token'
        },
        body: {
          "name": bookName.text,
          "code_number" : codeNumber.text,
          "grade":batchId,
        },
      );
      print(response.body);
      setState(() {
        loading = false;
        success = true;
      });
    }
    catch(e){

    }
  }
  final _formkey = GlobalKey<FormState>();
  var batch_list=[
    'Select a batch',
  ];
  String value = 'Select a batch';
  @override
  Widget build(BuildContext context) {


    return Scaffold(
      appBar: AppBar(
        title: Text('Add Books',style: TextStyle(fontFamily: 'Aerial',color: white),),
        backgroundColor: blue,
        elevation: 0,

      ),
      body: Container(
        color: lightBlue.withOpacity(0.2),
        width: double.infinity,
        height: double.infinity,
        child: BackdropFilter(
          filter: ImageFilter.blur(
            sigmaX: 5.0,
            sigmaY: 5.0,
          ),
          child: SingleChildScrollView(
            child: Container(
              margin: const EdgeInsets.all(24),
              child: Form(
                key: _formkey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text('Book Name',style: TextStyle(fontSize: 16),),
                    SizedBox(height: 10,),
                    DefaultTextField('Book Name', bookName,),
                    SizedBox(height: 15,),
                    Text('Batch',style: TextStyle(fontSize: 16),),
                    SizedBox(height: 10,),
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
                              getClassId("$value");
                            });}
                        ),
                      ),
                    ),
                    SizedBox(height: 15,),
                    Text('Code Number',style: TextStyle(fontSize: 16),),
                    SizedBox(height: 10,),
                    DefaultTextField('Code Number',codeNumber,),
                    SizedBox(height: 10,),
                    success ? Text('Book Added Succesfully',style: TextStyle(fontSize: 16,color: green),):Container(),
                    SizedBox(height: 10,),
                    ElevatedButton(onPressed: (){createBook();}, child: loading ? Padding(
                      padding: const EdgeInsets.fromLTRB(0,0,0,0),
                      child: SizedBox(
                          height: 15,
                          width: 15,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: white,
                          )),
                    ):  Padding(
                      padding: const EdgeInsets.all(4.0),
                      child: Text('Submit',style: TextStyle(fontSize: 18),),
                    )),
                    SizedBox(
                      height: 10,
                    ),
                    ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          primary: green,
                        ),
                        onPressed: (){ _goToBookList();},
                        child: Text("Show Books" ,style: TextStyle(fontSize: 16),)
                    ),

                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

Widget DefaultTextField(String hintText, TextEditingController controller){
  return Container(
    decoration: BoxDecoration(
      color: Colors.white,
      border: Border.all(color: grey5),
      borderRadius: BorderRadius.circular(5),
    ),
    child: TextField(
      controller: controller,
      decoration: InputDecoration(
        contentPadding: EdgeInsets.fromLTRB(10,0,0,0),
        border: InputBorder.none,
        fillColor: Colors.white,
        hintText: hintText,
        hintStyle: TextStyle(color: grey3),
      ),
    ),
  );
}
DropdownMenuItem<String> buildMenuItem(String batch){
  return DropdownMenuItem(
      value: batch,
      child: Text(
        batch,
      ));

}