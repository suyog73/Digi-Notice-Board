// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:introduction_screen/introduction_screen.dart';
import 'package:lottie/lottie.dart';
import 'package:notice_board/screens/auth_screens/landing_screen.dart';

import '../helpers/constants.dart';

class OnBoardingScreen extends StatelessWidget {
  static String id = 'onBoarding_screen';

  const OnBoardingScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return SafeArea(
      child: Scaffold(
        extendBodyBehindAppBar: true,
        body: SizedBox(
          height: size.height,
          child: IntroductionScreen(
            pages: [
              PageViewModel(
                title: 'Welcome to $appName',
                body:
                    'Now create and upload any type of notice in just few steps',
                image: Center(
                  child: Lottie.asset("assets/lottie/welcome.json"),
                ),
                decoration: kGetPageDecoration(),
              ),
              PageViewModel(
                title: 'Acknowledge Notice',
                body:
                    'Keep a track on students who have acknowledge the notice or not',
                image: Center(
                  child: Lottie.asset("assets/lottie/track.json"),
                ),
                decoration: kGetPageDecoration(),
              ),
              PageViewModel(
                title: 'Get notifications',
                body:
                    'Get quick notification as soon as notice  gets uploaded.',
                image: Center(
                  child: Lottie.asset("assets/lottie/notification.json"),
                ),
                decoration: kGetPageDecoration(),
              ),
            ],
            done: Text(
              'Login',
              style: TextStyle(
                fontWeight: FontWeight.w600,
                color: Colors.black,
                fontSize: 20,
              ),
            ),
            onDone: () => goToHome(context),
            showSkipButton: true,
            skip: Text(
              'Skip',
              style: TextStyle(color: Colors.black, fontSize: 18),
            ),
            onSkip: () => goToHome(context),
            next: Icon(
              Icons.arrow_forward,
              color: Colors.black,
              size: 26,
            ),
            dotsDecorator: kGetDotDecoration(),
            globalBackgroundColor: kOrangeColor,
            skipOrBackFlex: 0,
            nextFlex: 0,
          ),
        ),
      ),
    );
  }

  void goToHome(context) => Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (context) => LandingScreen(),
        ),
      );
}
