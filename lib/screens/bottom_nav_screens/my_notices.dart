// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';
import 'package:notice_board/helpers/constants.dart';
import 'package:notice_board/screens/bottom_nav_screens/create_notice/create_notice_screen.dart';
import 'package:notice_board/widgets/auth_button.dart';
import 'package:notice_board/widgets/my_appbar.dart';
import 'package:provider/provider.dart';

import '../../models/notice_model.dart';
import '../../models/user_model.dart';
import '../../providers/user_model_provider.dart';
import '../../widgets/notice_bubble.dart';

class MyNotices extends StatefulWidget {
  const MyNotices({Key? key}) : super(key: key);

  @override
  State<MyNotices> createState() => _MyNoticesState();
}

class _MyNoticesState extends State<MyNotices> {
  CollectionReference noticeCollection =
      FirebaseFirestore.instance.collection("notice");

  @override
  Widget build(BuildContext context) {
    UserModel userModel =
        Provider.of<UserModelProvider>(context, listen: false).currentUser;

    Size size = MediaQuery.of(context).size;

    return Scaffold(
      // backgroundColor: kBackGroundColor,
      appBar: MyAppBar(
        appBarName: 'My Notices',
        isBack: false,
      ),
      body: SizedBox(
        width: size.width,
        child: Padding(
          padding: const EdgeInsets.only(top: 18.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    StreamBuilder<QuerySnapshot>(
                      stream: noticeCollection
                          .orderBy('createdAt', descending: true)
                          .where("ownerUid", isEqualTo: userModel.uid)
                          .snapshots(),
                      builder: (BuildContext context,
                          AsyncSnapshot<QuerySnapshot> snapshot) {
                        if (!snapshot.hasData) {
                          return Expanded(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                CircularProgressIndicator(color: kOrangeColor),
                              ],
                            ),
                          );
                        }
                        if (snapshot.data != null && snapshot.hasData) {
                          // print(snapshot.data!.docs.length);
                          if (snapshot.data!.docs.isEmpty) {
                            return SizedBox(
                              height: size.height * 0.9 - 95,
                              child: Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 38.0),
                                    child: Card(
                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 8.0, vertical: 18),
                                        child: Text(
                                          "You haven't uploaded any notice yet",
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                              fontSize: 24,
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ),
                                    ),
                                  ),
                                  // SizedBox(height: size.height * 0.05),
                                  Lottie.asset(
                                    'assets/lottie/nothing.json',
                                    fit: BoxFit.cover,
                                  ),
                                  // SizedBox(height: size.height * 0.05),
                                  AuthButton(
                                    size: size,
                                    width: size.width * 0.45,
                                    name: "Create notice",
                                    onTap: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              CreateNoticeScreen(),
                                        ),
                                      );
                                    },
                                    color: kOrangeColor,
                                  ),
                                ],
                              ),
                            );
                          } else {
                            List<NoticeModel> noticeList = [];
                            for (var document in snapshot.data!.docs) {
                              Map<String, dynamic> data =
                                  document.data()! as Map<String, dynamic>;
                              NoticeModel notice = NoticeModel.fromJson(data);
                              notice.noticeId = document.id;
                              noticeList.add(notice);
                            }

                            return Expanded(
                              child: Align(
                                alignment: Alignment.topLeft,
                                child: ListView.builder(
                                  shrinkWrap: true,
                                  physics: BouncingScrollPhysics(),
                                  itemCount: noticeList.length,
                                  itemBuilder: (context, index) {
                                    NoticeModel localNotice = noticeList[index];

                                    return NoticeBubble(
                                        noticeModel: localNotice);
                                  },
                                ),
                              ),
                            );
                          }
                        } else {
                          return Container();
                        }
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
