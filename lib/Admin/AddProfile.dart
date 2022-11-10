import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../Colors.dart';
import '../Connection/conn.dart';
import '../Fonts.dart';
import 'package:http/http.dart' as http;
import 'package:eacademia/Connection/conn.dart';
class AddProfile extends StatefulWidget {
  const AddProfile({Key? key}) : super(key: key);

  @override
  State<AddProfile> createState() => _AddProfileState();
}

class _AddProfileState extends State<AddProfile> {
  TextEditingController about = new TextEditingController();
  @override
  // ignore: must_call_super
  void initState() {
    getToken();
  }
  String refresh_token='';
  String access_token='';
  String email = '';

  getToken() async{
    final SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    setState(() {
      refresh_token = sharedPreferences.get('refresh_token').toString();
      access_token = sharedPreferences.get('access_token').toString();

    });

  }
  bool loading =false;
  bool success = false;

  addProfile() async {
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
        Uri.parse("http://$host:8000/about_admin/"),
        headers: {
          'Authorization' : 'Bearer $access_token'
        },
        body: {
            'about' : about.text
        },
      );
      print(response.body);
      setState(() {
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
        title: Text('Add Profile',style: fontStyle , ),
        backgroundColor: blue,
        elevation: 0,
        excludeHeaderSemantics: true,
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(0,10,0,0),
              child: Text('About',style: TextStyle(fontSize: 25,fontWeight: FontWeight.w500),),
            ),
            SizedBox(
              height: 15,
            ),
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border.all(color: grey5),
                borderRadius: BorderRadius.circular(5),

              ),
              child: TextFormField(
                controller: about,
                minLines: 8,
                maxLines: 15,
                decoration: InputDecoration(
                  contentPadding: EdgeInsets.fromLTRB(10,10,0,0),
                  border: InputBorder.none,
                  fillColor: Colors.white,
                  hintText: 'About.....',
                  hintStyle: TextStyle(color: grey3),
                ),
              ),
            ),
            SizedBox(
              height: 15,
            ),
            ElevatedButton(
                style: ElevatedButton.styleFrom(
                  primary: blue,
                ),
                onPressed: (){ addProfile();},
                child: Text("Add Profile" ,style: TextStyle(fontSize: 16),)
            ),

          ],
        ),
      ),
    );
  }
}
