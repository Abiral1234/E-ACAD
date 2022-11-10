import 'package:flutter/material.dart';

class ChooseView extends StatefulWidget {
  const ChooseView({Key? key}) : super(key: key);

  @override
  State<ChooseView> createState() => _ChooseViewState();
}

class _ChooseViewState extends State<ChooseView> {
  _gotoAdmin(){
    Navigator.of(context).pushNamed('/Admin');
  }
  _gotoTeacher(){
    Navigator.of(context).pushNamed('/Teacher');
  }
  _gotoStudent(){
    Navigator.of(context).pushNamed('/Student');
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(onPressed: (){_gotoAdmin(); }, child: Text("Admin")),
            ElevatedButton(onPressed: (){_gotoTeacher();}, child: Text("Teacher")),
            ElevatedButton(onPressed: (){_gotoStudent();}, child: Text("Student")),

          ],
        ),
      ),
    );
  }
}
