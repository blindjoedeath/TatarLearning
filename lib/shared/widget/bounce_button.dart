

import 'package:flutter/material.dart';

class BounceButton extends StatelessWidget{

  final double height;
  final double width;
  final Color color;
  final TextStyle textStyle;
  final String text;

  BounceButton({this.height = 80, this.width = 270, this.color = Colors.white,
                this.textStyle = const TextStyle(
                                      fontSize: 20.0,
                                      fontWeight: FontWeight.bold,
                                      color: Color(0xFF8185E2),
                                    ),
                this.text});


  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      width: width,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(100.0),
        color: color
      ),
      child: Center(
        child: Text(
          text,
          style: textStyle
        ),
      ),
    );
  }

  

}