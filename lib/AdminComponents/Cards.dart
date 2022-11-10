import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../Colors.dart';
import '../Fonts.dart';

class Cards extends StatelessWidget {

  String imageUrl;
  String title;
  Cards(this.imageUrl,this.title);

  @override
  Widget build(BuildContext context) {
    double height =MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;

    return Padding(
      padding: const EdgeInsets.fromLTRB(10,20,10,0),
        child: Container(
          width: 110,
          height: 120,
            decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(width: 2,color: Colors.white)
            ),
            child: IgnorePointer(
              ignoring: true,
              child: ElevatedButton(
                onPressed:(){

                },
                style: ElevatedButton.styleFrom(
                  primary: Colors.white, //background color
                  onPrimary: Colors.black,//text color
                      onSurface: Colors.orange,
                      shadowColor: blue,
                  elevation: 2
                  ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SvgPicture.asset('$imageUrl',fit:BoxFit.contain,width: 64,height: 64,),
                    SizedBox(
                      height: 0,
                    ),
                    Text('$title',
                          softWrap: true,
                          maxLines: 2,
                          style: small,
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ),
      ),

    );
  }
}
