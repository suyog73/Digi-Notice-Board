// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:notice_board/helpers/constants.dart';

class MyButton extends StatelessWidget {
  const MyButton({Key? key, required this.text, this.isAdmin = false})
      : super(key: key);
  final String text;
  final bool isAdmin;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Container(
      alignment: Alignment.center,
      height: 54,
      width: size.width * 0.6,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(27),
        color: isAdmin ? kOrangeColor : kVioletShade,
      ),
      child: Text(
        text,
        style: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.w500,
          color: Colors.white,
        ),
      ),
    );
  }
}

class MyButton1 extends StatelessWidget {
  const MyButton1({
    Key? key,
    required this.text,
    this.borderRadius = 27,
    this.color = kGreenShadeColor,
    this.textColor = Colors.black,
    this.width,
    this.height = 54,
  }) : super(key: key);
  final String text;
  final double borderRadius;
  final double? width, height;
  final Color color, textColor;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Container(
      alignment: Alignment.center,
      height: height,
      width: width ?? size.width * 0.4,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(borderRadius),
        color: color,
      ),
      child: Text(
        text,
        style: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.w500,
          color: textColor,
        ),
      ),
    );
  }
}
