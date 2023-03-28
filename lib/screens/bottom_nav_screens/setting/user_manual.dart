// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:notice_board/helpers/constants.dart';
import 'package:notice_board/widgets/my_appbar.dart';

class UserManual extends StatelessWidget {
  const UserManual({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: MyAppBar(appBarName: "User Manual"),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 18.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: size.height * 0.05),
            Row(
              children: [
                Image(
                  image: AssetImage("assets/images/logo.png"),
                  width: 55,
                ),
                SizedBox(width: 10),
                Text(
                  appName,
                  style: TextStyle(fontSize: 28, fontWeight: FontWeight.w400),
                ),
              ],
            ),
            SizedBox(height: size.height * 0.02),
            Divider(),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: size.height * 0.02),
                    Text(
                      "For Admins",
                      style: TextStyle(
                        fontSize: 26,
                        fontWeight: FontWeight.w600,
                        color: kOrangeColor,
                      ),
                    ),
                    Text(
                      adminUserManual,
                      style: TextStyle(fontSize: 16),
                    ),
                    SizedBox(height: size.height * 0.02),
                    Text(
                      "For Students",
                      style: TextStyle(
                        fontSize: 26,
                        fontWeight: FontWeight.w600,
                        color: kOrangeColor,
                      ),
                    ),
                    Text(
                      studentUserManual,
                      style: TextStyle(fontSize: 16),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
