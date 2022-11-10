import 'dart:convert';
import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../Colors.dart';
import 'package:open_file/open_file.dart';
import 'package:eacademia/Connection/conn.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart';
class CreateAssignmentPage extends StatefulWidget {
  String subjectId;
  CreateAssignmentPage({Key? key,required this.subjectId}) : super(key: key);

  @override
  State<CreateAssignmentPage> createState() => _CreateAssignmentPageState();
}

class _CreateAssignmentPageState extends State<CreateAssignmentPage> {
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

  }
  bool loading =false;
  bool success = false;
  File? assignmentFile;
  String fileName ='';
  CreateAssignment() async {
    setState(() {
      loading = true;
    });
    try {
      setState(() {
        loading = true;
      });

      var subjectData = {
        "id" :widget.subjectId
      };
      print("Creating Assignment ....");
        // var stream = new http.ByteStream(assignmentFile!.openRead());
        // stream.cast();
        // var length = await assignmentFile!.length();
        // String filename = basename(assignmentFile!.path);
        // print(stream);
        // print(length);
        // print(filename);
        // var Files = new http.MultipartFile('file',
        //   stream,
        //   length,
        //   filename: filename,
        // );
      var data = {
        "subject":{
          "id":widget.subjectId,
        },
        "title":title.text,
        "assigned_date":assignedDate,
        "deadline_date":deadlineDate,
        "status":"summited",
        // "file":Files
      };

      var response = await http.post(
          Uri.parse("http://$host:8000/teacher/assignment/"),
          headers: {
            'content-type': 'application/json',
            'Authorization': 'Bearer $access_token',
          },
          body:  jsonEncode(data),

      );
      print(response.body);
      print(response.statusCode);
      var data2 = jsonDecode(response.body.toString());
      String assignmentId = data2['id'].toString();
      print("The Assignmetn Id is");
      print(assignmentId);
      // var uri = Uri.parse("http://$host:8000/teacher/assignment/$assignmentId/");
      // var request = new http.MultipartRequest('PATCH', uri);
      // request.headers["content-type"] = 'application/json';
      // request.headers['Authorization'] ='Bearer $access_token';
      // print("File length is");
      // // print(assignmentFile?.length());
      // // if(assignmentFile?.length() != null) {
      //   var stream = new http.ByteStream(assignmentFile!.openRead());
      //   stream.cast();
      //   var length = await assignmentFile!.length();
      //   String filename = basename(assignmentFile!.path);
      //   var Files = new http.MultipartFile('file',
      //     stream,
      //     length,
      //     filename: filename,
      //   );
      //   print(Files);
      //   request.files.add(Files);
      // // }
      // var response2 = await request.send();
      // final data3 = await response2.stream.bytesToString();;
      // print(data3);
      // final url = Uri.parse("http://$host:8000/teacher/assignment/");
      // var request = http.MultipartRequest('POST', url);
      // request = jsonToFormData(request, data);
      // request.headers['X-Requested-With'] = "XMLHttpRequest";
      // request.headers['Authorization'] = "Bearer $access_token";
      // print(data);
      // var uri = Uri.parse("http://$host:8000/teacher/assignment/");
      // var request = new http.MultipartRequest('POST', uri);
      // request.headers['content-type'] = 'application/json';
      // request.headers['Authorization'] ='Bearer $access_token';
      // request.fields['title']=title.text;
      // request.fields["subject"]= jsonEncode(subjectData);
      // request.fields['assigned_date']=assignedDate;
      // request.fields['deadline_date']=deadlineDate;
      // request.fields['status']="submitted";
      // print("Assignment NOte length is");
      // print(assignmentFile?.length());
      // if(assignmentFile?.length() != null) {
      //   var stream = new http.ByteStream(assignmentFile!.openRead());
      //   stream.cast();
      //   var length = await assignmentFile!.length();
      //   String filename = basename(assignmentFile!.path);
      //   var Files = new http.MultipartFile('file',
      //     stream,
      //     length,
      //     filename: filename,
      //   );
      //   print(Files);
      //   request.files.add(Files);
      // }
      // var response = await request.send();
      // final data2 = await response.stream.bytesToString();;
      // print(data2);
      // print("The Status Code is");
      // print(response.statusCode);
      setState(() {
        loading = false;
        success = true;
      });
    }
    catch(e){
      print(e);
    }
  }
  jsonToFormData(http.MultipartRequest request, Map<String, dynamic> data) {
    for (var key in data.keys) {
      request.fields[key] = data[key].toString();
    }
    return request;
  }
  TextEditingController title = new TextEditingController();
  TextEditingController description = new TextEditingController();
  String assignedDate = DateFormat('yyyy-MM-dd').format(DateTime.now());
  String deadlineDate = DateFormat('yyyy-MM-dd').format(DateTime.now());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Create Assignment'),
        backgroundColor: blue,
        elevation: 0,
        excludeHeaderSemantics: true,
        foregroundColor: Colors.white,

      ),
      body: SingleChildScrollView(
        child: Container(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Assignment title",style: TextStyle(fontSize: 20,fontWeight: FontWeight.w500),),
                SizedBox(height: 10,),
                DefaultTextField("Title",title),
                SizedBox(height: 10,),
                Text("Description",style: TextStyle(fontSize: 20,fontWeight: FontWeight.w500),),
                SizedBox(height: 10,),
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border.all(color: grey5),
                    borderRadius: BorderRadius.circular(5),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(0,10,0,10),
                    child: TextField(
                      controller: description ,
                      maxLines: 5,
                      minLines: 5,
                      decoration: InputDecoration(
                        contentPadding: EdgeInsets.fromLTRB(10,0,0,0),
                        border: InputBorder.none,
                        fillColor: Colors.white,
                        hintText: "Description",
                        hintStyle: TextStyle(color: grey3),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 10,),
                Text("Assigned Date",style: TextStyle(fontSize: 20,fontWeight: FontWeight.w500),),
                SizedBox(height: 10,),
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border.all(color: grey5),
                    borderRadius: BorderRadius.circular(5),
                  ),
                  child: ListTile(
                    onTap: (){
                      showDatePicker(context: context,
                          initialDate: DateTime.now(),
                          firstDate: DateTime(2000),
                          lastDate: DateTime(2222)
                      ).then((date) {
                        setState(() {
                          assignedDate = DateFormat('yyyy-MM-dd').format(date!);
                        });
                      });
                    },
                    title:Text(assignedDate),
                    trailing: Icon(Icons.date_range),
                  ),
                ),
                SizedBox(height: 20,),
                Text("Deadline Date",style: TextStyle(fontSize: 20,fontWeight: FontWeight.w500),),
                SizedBox(height: 10,),
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border.all(color: grey5),
                    borderRadius: BorderRadius.circular(5),
                  ),
                  child: ListTile(
                    onTap: (){
                      showDatePicker(context: context,
                          initialDate: DateTime.now(),
                          firstDate: DateTime(2000),
                          lastDate: DateTime(2222)
                      ).then((date) {
                        setState(() {
                          deadlineDate = DateFormat('yyyy-MM-dd').format(date!);
                        });
                      });
                    },
                    title:Text( deadlineDate),
                    trailing: Icon(Icons.date_range),
                  ),
                ),
                SizedBox(height: 20,),
                fileName==''?Container():Card(
                  color: Colors.deepPurple,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10.0),
                    child: Container(
                      width: Get.width,
                      height: 20,
                      child:Center(child: Text(fileName,style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                      ),)) ,
                    ),
                  ),
                ),
                SizedBox(height: 20,),
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    color: green,
                  ),
                  child: ListTile(
                    onTap: () async{
                      // final result = await FilePicker.platform.pickFiles(allowMultiple: true);
                      final result = await FilePicker.platform.pickFiles();
                      if(result == null) return;
                      setState(() {
                         final file = result.files.first ;
                        fileName = file.name;
                         assignmentFile = File(file.path!);
                        print(file.size);
                        print(file.extension);
                        print("The file name is "+ fileName);
                      });
                    },
                    leading: FaIcon(FontAwesomeIcons.upload,color: white,size: 30,),
                    title: Text("Upload File",style: TextStyle(fontSize: 20,fontWeight: FontWeight.w700,color: white),),
                    subtitle: Text("Attach file with the assignment",style: TextStyle(fontSize: 16,fontWeight: FontWeight.w500,color: white),),
                  ),
                ),
                SizedBox(height: 20,),
                ElevatedButton(
                    onPressed: (){CreateAssignment();},
                    child: Text("Submit",style: TextStyle(fontSize: 18,fontWeight: FontWeight.w500),)),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
void openFile(PlatformFile file){
  OpenFile.open(file.path!);
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