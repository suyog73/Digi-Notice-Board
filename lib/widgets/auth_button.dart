// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';

class AuthButton extends StatelessWidget {
  const AuthButton({
    Key? key,
    required this.size,
    required this.name,
    required this.onTap,
    required this.color,
    this.textColor = Colors.black,
    this.width = 0,
  }) : super(key: key);

  final Size size;
  final String name;
  final Function onTap;
  final Color color, textColor;
  final double width;
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        onTap();
      },
      child: Container(
        alignment: Alignment.center,
        height: 50,
        width: width == 0 ? size.width * 0.4 : width,
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(15),
        ),
        child: Text(
          name,
          style: TextStyle(
            color: textColor,
            fontWeight: FontWeight.bold,
            fontSize: 26,
          ),
        ),
      ),
    );
  }
}
