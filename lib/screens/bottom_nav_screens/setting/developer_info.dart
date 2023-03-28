// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:notice_board/helpers/constants.dart';
import 'package:notice_board/widgets/my_appbar.dart';
import 'package:url_launcher/url_launcher.dart';

class DeveloperInfo extends StatelessWidget {
  const DeveloperInfo({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    String college = "Walchand College of Engineering, Sangli";

    void launchEmail(emailAddress) async {
      final Uri params = Uri(
          scheme: 'mailto',
          path: emailAddress,
          queryParameters: {'subject': '', 'body': ''});
      String url = params.toString();
      if (await canLaunch(url)) {
        await launch(url);
      } else {
        print('Could not launch $url');
      }
    }

    launchURL(localUrl) async {
      String url = localUrl;
      if (await canLaunch(url)) {
        await launch(url);
      } else {
        throw 'Could not launch $url';
      }
    }

    return Scaffold(
      appBar: MyAppBar(appBarName: 'Developer Information'),
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
            Divider(color: Colors.black),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: size.height * 0.02),
                    Text(
                      "Guide: ",
                      style: TextStyle(fontSize: 22),
                    ),
                    SizedBox(height: 5),
                    MyCards(
                      name: 'Dr. D. B. Kulkarni',
                      position: 'Professor of Information Technology',
                      college: college,
                      isDev: false,
                      onMail: () => launchEmail(dbkSirEmail),
                    ),
                    SizedBox(height: size.height * 0.02),
                    Divider(color: Colors.black),
                    SizedBox(height: size.height * 0.02),
                    Text(
                      "Developers: ",
                      style: TextStyle(fontSize: 22),
                    ),
                    SizedBox(height: 5),
                    MyCards(
                      name: 'Suyog Patil',
                      position: 'Student of Information Technology',
                      // information: "Full Stack Flutter Developer",
                      college: college,
                      onMail: () => launchEmail(suyogEmail),
                      onGitHub: () => launchURL(suyogGithub),
                      onLinkedIn: () => launchURL(suyogLinkedIn),
                    ),
                    SizedBox(height: 10),
                    MyCards(
                      name: 'Shivaprasad Umshette',
                      position: 'Student of Information Technology',
                      college: college,
                      onMail: () => launchEmail(shivaEmail),
                      onGitHub: () => launchURL(shivaGithub),
                      onLinkedIn: () => launchURL(shivaLinkedIn),
                    ),
                    SizedBox(height: 10),
                    MyCards(
                      name: 'Rutuja Khillare',
                      position: 'Student of Information Technology',
                      college: college,
                      onMail: () => launchEmail(rutujaEmail),
                      onGitHub: () => launchURL(rutujaGithub),
                      onLinkedIn: () => launchURL(rutujaLinkedIn),
                    ),
                    SizedBox(height: 10),
                    MyCards(
                      name: 'Saurabh Nakade',
                      position: 'Student of Information Technology',
                      college: college,
                      onMail: () => launchEmail(saurabhEmail),
                      onGitHub: () => launchURL(saurabhGithub),
                      onLinkedIn: () => launchURL(saurabhLinkedIn),
                    ),
                    SizedBox(height: 10),
                    MyCards(
                      name: 'Dnyaneshawar Shinde',
                      position: 'Student of Information Technology',
                      college: college,
                      onMail: () => launchEmail(dnyEmail),
                      onGitHub: () => launchURL(dnyGithub),
                      onLinkedIn: () => launchURL(dnyLinkedIn),
                    ),
                    SizedBox(height: 10),
                    MyCards(
                      name: 'Sumit Pawade',
                      position: 'Student of Information Technology',
                      college: college,
                      onMail: () => launchEmail(sumitEmail),
                      onGitHub: () => launchURL(sumitGithub),
                      onLinkedIn: () => launchURL(sumitLinkedIn),
                    ),
                    SizedBox(height: 10),
                    MyCards(
                      name: 'Omkar Birajdar',
                      position: 'Student of Information Technology',
                      college: college,
                      onMail: () => launchEmail(omkarEmail),
                      onGitHub: () => launchURL(omkarGithub),
                      onLinkedIn: () => launchURL(omkarLinkedIn),
                    ),
                    SizedBox(height: 10),
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

class MyCards extends StatelessWidget {
  const MyCards({
    Key? key,
    required this.name,
    required this.position,
    required this.college,
    this.isDev = true,
    this.color = kOrangeColor,
    this.onMail,
    this.onLinkedIn,
    this.onGitHub,
    this.information = "",
  }) : super(key: key);

  final String name, position, college, information;
  final bool isDev;
  final Color color;
  final Function? onMail, onLinkedIn, onGitHub;

  @override
  Widget build(BuildContext context) {
    return Card(
      color: color,
      child: SizedBox(
        // height: 60,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 18.0, vertical: 18),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    name,
                    style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
                  ),
                  if (!isDev)
                    InkWell(
                      onTap: () async {
                        onMail!();
                      },
                      child: Icon(
                        Icons.mail,
                        color: kVioletShade,
                        size: 32,
                      ),
                    ),
                ],
              ),
              SizedBox(height: 3),
              if (information != "")
                Text(
                  information,
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                ),
              Text(
                position,
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w400),
              ),
              Text(
                college,
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w400),
              ),
              if (isDev) ...[
                SizedBox(height: 10),
                Row(
                  children: [
                    InkWell(
                      onTap: () async {
                        onMail!();
                      },
                      child: Icon(
                        Icons.mail,
                        color: kVioletShade,
                        size: 32,
                      ),
                    ),
                    SizedBox(width: 20),
                    InkWell(
                      onTap: () async {
                        onLinkedIn!();
                      },
                      child: Icon(
                        FontAwesomeIcons.linkedin,
                        color: Colors.blue,
                        size: 32,
                      ),
                    ),
                    SizedBox(width: 20),
                    InkWell(
                      onTap: () async {
                        onGitHub!();
                      },
                      child: Icon(
                        FontAwesomeIcons.github,
                        size: 32,
                      ),
                    ),
                  ],
                ),
              ]
            ],
          ),
        ),
      ),
    );
  }
}
