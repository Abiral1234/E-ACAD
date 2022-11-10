import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import '../Colors.dart';
import '../TeacherComponents/DefaultTextField.dart';
import 'package:eacademia/Connection/conn.dart';
final faculties=[
  '-- SELECT YOUR CLASS --',
  'BESE_2015 (AOS)',
  'BESE_2016 (DSA)',
  'BESE_2017 (ADA)',
  'BESE_2018 (EE)',

];
class TeacherNotes extends StatefulWidget {
  const TeacherNotes({Key? key}) : super(key: key);

  @override
  State<TeacherNotes> createState() => _TeacherNotesState();
}

class _TeacherNotesState extends State<TeacherNotes> {
  String? value = faculties[0];
  TextEditingController student = new TextEditingController();
  @override
  Widget build(BuildContext context) {

    return SingleChildScrollView(
      child: Container(
        padding: EdgeInsets.fromLTRB(20, 30, 20, 20),
        color:  lightBlue.withOpacity(0.2),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children:  [
            Padding(
              padding: const EdgeInsets.fromLTRB(5,0,0,0),
              child: Text('Send Notes To Student',style: TextStyle(fontSize: 18,fontWeight: FontWeight.w400),),
            ),
            SizedBox(
              height: 10,
            ),
            Container(
              padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border.all(color: grey5),
                borderRadius: BorderRadius.circular(5),
              ),
              child: DropdownButtonHideUnderline(
                child:
                DropdownButton<String>(
                    iconSize: 35,
                    icon: Icon(Icons.arrow_drop_down_sharp),
                    value: value,
                    isExpanded: true,
                    items: faculties.map(buildMenuItem).toList(),
                    onChanged: (value){ setState(() {
                      this.value=value;
                    });}
                ),
              ),
            ),
            SizedBox(
              height: 16,
            ),
            DefaultTextField(hintText: 'Select Student',controller: student,),
            SizedBox(height: 15,),
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border.all(color: grey5),
                borderRadius: BorderRadius.circular(5),

              ),
              child: TextFormField(
                minLines: 5,
                maxLines: 10,
                decoration: InputDecoration(
                  contentPadding: EdgeInsets.fromLTRB(10,10,0,10),
                  border: InputBorder.none,
                  fillColor: Colors.white,
                  hintText: 'Message....',
                  hintStyle: TextStyle(color: grey3),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 14.0),
              child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      primary: blue,
                      minimumSize: Size(800, 40)
                  ),
                  onPressed: (){},
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        child: FaIcon(FontAwesomeIcons.file),
                      ),
                      Text("Attach File",style: TextStyle(fontSize: 18),),
                    ],

                  )),
            ),

            ElevatedButton(
                style: ElevatedButton.styleFrom(
                  primary: blue,
                ),
                onPressed: (){},
                child: Text('Submit',style: TextStyle(fontSize: 18),)
            ),
            SizedBox(
              height: 10,
            ),
          ],
        ),
      ),
    );
  }
}
DropdownMenuItem<String> buildMenuItem(String faculty){
  return DropdownMenuItem(
      value: faculty,
      child: Text(
        faculty,
      ));

}