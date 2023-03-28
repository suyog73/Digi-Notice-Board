// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:notice_board/helpers/constants.dart';
import 'package:notice_board/models/user_model.dart';
import 'package:notice_board/services/user_services.dart';

import '../../../widgets/image_viewer.dart';

class StudentProfile extends StatefulWidget {
  const StudentProfile({
    Key? key,
    required this.userUid,
    required this.isCurrentUserAdmin,
  }) : super(key: key);

  final String userUid;
  final bool isCurrentUserAdmin;

  @override
  State<StudentProfile> createState() => _StudentProfileState();
}

class _StudentProfileState extends State<StudentProfile> {
  UserModel? userModel;
  int totalFollowers = 0;

  Timestamp? createdAt;

  Future<UserModel?> getData() async {
    print(widget.userUid);

    UserModel? um = widget.isCurrentUserAdmin
        ? await AdminServices().getAdmin(widget.userUid)
        : await StudentServices().getStudent(widget.userUid);

    return um;
  }

  @override
  void didChangeDependencies() async {
    userModel = await getData();
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return WillPopScope(
      onWillPop: () {
        return Future.value(true);
      },
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: mainColor(context),
          title: Text(
            userModel!.name.toString(),
            style: TextStyle(
              color: Colors.black,
              fontSize: 22,
            ),
          ),
          iconTheme: IconThemeData(color: Colors.black),
          centerTitle: true,
        ),
        body: SingleChildScrollView(
          physics: BouncingScrollPhysics(),
          child: Center(
            child: Column(
              children: [
                SizedBox(height: size.height * 0.06),
                ImageViewer(
                  width: 160,
                  height: 160,
                  finalWidth: size.width,
                  finalHeight: 500,
                  urlDownload: userModel!.imageUrl.toString(),
                  isAdmin: true,
                ),
                SizedBox(height: 50),
                Text(
                  userModel!.name.toString(),
                  style: TextStyle(color: Colors.black, fontSize: 28),
                ),
                SizedBox(height: 10),
                Text(
                  userModel!.email.toString(),
                  style: TextStyle(
                      color: Colors.black.withOpacity(0.5), fontSize: 18),
                ),
                SizedBox(height: 30),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 32),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Divider(color: Colors.grey.shade500),
                      SizedBox(height: 10),
                      NewRow(
                        property: (userModel!.prn == "")
                            ? userModel!.adminCategory.toString()
                            : userModel!.prn.toString(),
                        icon: Icons.verified_user_sharp,
                        color: mainColor(context),
                      ),
                      SizedBox(height: 10),
                      if (userModel!.branch != "" &&
                          userModel!.branch != "null") ...[
                        NewRow(
                          property: userModel!.branch.toString(),
                          icon: FontAwesomeIcons.codeBranch,
                          color: mainColor(context),
                        ),
                        SizedBox(height: 10),
                        if (userModel!.year != "" && userModel!.year != "null")
                          NewRow(
                            property: userModel!.year.toString() +
                                ((widget.isCurrentUserAdmin == false)
                                    ? " Student"
                                    : " "),
                            icon: FontAwesomeIcons.calendar,
                            color: mainColor(context),
                          )
                      ],
                      SizedBox(height: 10),
                      Divider(color: Colors.grey.shade500),
                      SizedBox(height: 10),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class NewRow extends StatelessWidget {
  const NewRow({
    Key? key,
    required this.property,
    required this.icon,
    this.color = kLightBlueShadeColor,
  }) : super(key: key);

  final String property;
  final IconData icon;
  final Color color;

  @override
  Widget build(BuildContext context) {
    Color textColor = kBlueShadeColor.withOpacity(0.7);

    return Padding(
      padding: const EdgeInsets.only(left: 18.0),
      child: Row(
        children: [
          Icon(icon, color: color),
          SizedBox(width: 10),
          Expanded(
            child: Text(
              property,
              style: TextStyle(color: textColor, fontSize: 20),
            ),
          ),
        ],
      ),
    );
  }
}
