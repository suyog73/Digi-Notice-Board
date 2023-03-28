// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:notice_board/helpers/constants.dart';
import 'package:notice_board/models/notice_model.dart';
import 'package:notice_board/models/user_model.dart';
import 'package:notice_board/services/notice_services.dart';
import 'package:notice_board/widgets/notice_bubble.dart';
import 'package:provider/provider.dart';

import '../../../providers/user_model_provider.dart';

class PriorityWiseNotices extends StatefulWidget {
  const PriorityWiseNotices({Key? key, required this.priority})
      : super(key: key);

  @override
  State<PriorityWiseNotices> createState() => _PriorityWiseNoticesState();

  final int priority;
}

class _PriorityWiseNoticesState extends State<PriorityWiseNotices> {
  CollectionReference noticeCollection =
      FirebaseFirestore.instance.collection("notice");

  @override
  Widget build(BuildContext context) {
    UserModel userModel =
        Provider.of<UserModelProvider>(context, listen: false).currentUser;

    Size size = MediaQuery.of(context).size;

    return Scaffold(
      // backgroundColor: kBackGroundColor,
      appBar: AppBar(
        backgroundColor: mainColor(context),
        iconTheme: IconThemeData(color: textColor(context)),
        title: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            children: [
              Text(
                widget.priority.toString(),
                style: TextStyle(
                  color: textColor(context),
                  fontSize: 26,
                  fontWeight: FontWeight.w500,
                ),
              ),
              Icon(Icons.star, color: Colors.amber),
              Text(
                " Priority Notices",
                style: TextStyle(
                  color: textColor(context),
                  fontSize: 26,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ),

      body: SizedBox(
        width: size.width,
        child: Padding(
          padding: const EdgeInsets.only(top: 18.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Expanded(
                child: StreamBuilder(
                    stream: FirebaseFirestore.instance
                        .collection('students')
                        .where("Info.uid", isEqualTo: userModel.uid)
                        .snapshots(),
                    builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return Center(
                          child: CircularProgressIndicator(
                              color: mainColor(context)),
                        );
                      } else if (snapshot.hasData) {
                        var currentUser = snapshot.data!.docs;
                        if (currentUser.isNotEmpty) {
                          List priority = currentUser[0]['Priority1'];

                          return StreamBuilder<List<NoticeModel>>(
                            stream: NoticeServices().getNotices(),
                            builder: (context,
                                AsyncSnapshot<List<NoticeModel>> snapshot) {
                              if (snapshot.connectionState ==
                                  ConnectionState.waiting) {
                                return Center(
                                    child: CircularProgressIndicator(
                                        color: mainColor(context)));
                              } else if (snapshot.hasData) {
                                List<NoticeModel> noticeList = snapshot.data!;

                                if (noticeList.isEmpty) {
                                  return Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      // Lottie.asset(
                                      //     "assets/lottie/noFollower.json"),
                                      Text(
                                        "No notices are there with priority ${widget.priority}",
                                        style: TextStyle(
                                            fontSize: 24,
                                            fontWeight: FontWeight.w500),
                                      ),
                                    ],
                                  );
                                } else {
                                  List<NoticeModel> noticeList = snapshot.data!;

                                  return ListView.builder(
                                    physics: BouncingScrollPhysics(),
                                    itemCount: noticeList.length,
                                    itemBuilder: (context, index) {
                                      NoticeModel localNotice =
                                          noticeList[index];
                                      if (priority
                                          .contains(localNotice.noticeId)) {
                                        return NoticeBubble(
                                            noticeModel: localNotice);
                                      } else {
                                        return Container();
                                      }
                                    },
                                  );
                                }
                              } else {
                                return Container();
                              }
                            },
                          );
                        }
                      }
                      return Container();
                    }),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
