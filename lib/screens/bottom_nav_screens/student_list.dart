// List of students who seen the particular notice or not

// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:notice_board/helpers/constants.dart';
import 'package:notice_board/widgets/auth_button.dart';

class StudentList extends StatelessWidget {
  const StudentList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: mainColor(context),
        title: Text(
          "Student List",
          style: TextStyle(color: Colors.black),
        ),
        iconTheme: IconThemeData(color: Colors.black),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            AuthButton(
              size: size,
              name: "Zingur",
              onTap: () async {},
              color: Colors.redAccent,
            ),
          ],
        ),
      ),
    );
  }
}
