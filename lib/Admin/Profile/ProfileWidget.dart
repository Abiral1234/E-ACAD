import 'package:eacademia/Colors.dart';
import 'package:flutter/material.dart';


class ProfileWidget extends StatelessWidget {
  final String imagePath;
  final VoidCallback onClicked;
  const ProfileWidget({
    Key? key,
    required this.imagePath,
    required this.onClicked,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Stack(
          children:[
            buildImage(),
            Positioned(
              bottom: 0,
                right: 4,
                child:ClipOval(
                  child: Container(
                      padding: EdgeInsets.all(3),
                    color: lightBlue,
                      child:
                  ClipOval(
                    child: Container(
                      padding: EdgeInsets.all(10),
                      color: blue,
                        child: Icon(Icons.edit,size: 20,color: Colors.white,)),
                  )),
                ),
            ),


          ]
      ),
    );
  }
  Widget buildImage(){
    final image =NetworkImage(imagePath);
    return ClipOval(
      child: Container(
        color: Colors.grey.shade300,
        child: ClipOval(
          child: Image.asset(
            imagePath,
            fit: BoxFit.cover,
            width: 128,
            height: 128,
          ),
        ),
      ),
    );
  }

}

