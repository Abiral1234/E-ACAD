import 'package:flutter/material.dart';
import '../Colors.dart';
import '../Fonts.dart';

class EacademiaAppBar extends StatelessWidget {
  const EacademiaAppBar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text('E-ACADEMIA',style: bigFontStyle, ),
      backgroundColor: blue,
      elevation: 0,
      excludeHeaderSemantics: true,
      foregroundColor: Colors.white,
      actions: [
        Icon(Icons.notifications),
      ],


    );
  }
}

