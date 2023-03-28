// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:notice_board/helpers/constants.dart';
import 'package:notice_board/widgets/auth_button.dart';
import 'package:notice_board/screens/auth_screens/student_login_screen.dart';
import 'package:notice_board/screens/auth_screens/admin_login_screen.dart';

class LandingScreen extends StatelessWidget {
  const LandingScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: kVioletShade,
        title: Text(
          appName,
          style: TextStyle(fontSize: 24),
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              "Choose your category",
              style: TextStyle(
                fontSize: 30,
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(
                height: size.height * 0.5,
                child: Lottie.asset("assets/lottie/landing.json")),
            AuthButton(
              size: size,
              textColor: Colors.white,
              name: "Students",
              color: kVioletShade,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => StudentLoginScreen(),
                  ),
                );
              },
            ),
            SizedBox(height: 20),
            AuthButton(
              size: size,
              name: "Admins",
              color: kOrangeColor,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => AdminLoginScreen(),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
