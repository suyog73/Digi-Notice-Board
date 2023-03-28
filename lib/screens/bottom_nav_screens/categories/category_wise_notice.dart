// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:notice_board/helpers/constants.dart';
import 'package:provider/provider.dart';

import '../../../models/notice_model.dart';
import '../../../models/user_model.dart';
import '../../../providers/user_model_provider.dart';
import '../../../widgets/notice_bubble.dart';

class CategoryWiseNotice extends StatefulWidget {
  const CategoryWiseNotice({
    Key? key,
    required this.noticeCategory,
    this.noticeCategory2 = "",
  }) : super(key: key);

  final String noticeCategory;
  final String noticeCategory2;

  @override
  State<CategoryWiseNotice> createState() => _CategoryWiseNoticeState();
}

class _CategoryWiseNoticeState extends State<CategoryWiseNotice> {
  CollectionReference noticeCollection =
      FirebaseFirestore.instance.collection("notice");

  String setLocalBranch(idx) {
    return shortBranch[idx];
  }

  @override
  Widget build(BuildContext context) {
    UserModel userModel =
        Provider.of<UserModelProvider>(context, listen: false).currentUser;

    bool isAdmin = userModel.isAdmin;
    String uid = userModel.uid.toString();

    int idx1 = branches.indexOf(userModel.branch.toString(), 0);
    Size size = MediaQuery.of(context).size;

    String localNoticeCategory = widget.noticeCategory == "year"
        ? userModel.year.toString()
        : widget.noticeCategory == "branch"
            ? setLocalBranch(idx1)
            : widget.noticeCategory == "subject"
                ? widget.noticeCategory2
                : widget.noticeCategory == "noticeType"
                    ? widget.noticeCategory2
                    : "";

    // print("Category");
    // print(widget.noticeCategory);
    // print(localNoticeCategory);

    return Scaffold(
      // backgroundColor: kBackGroundColor,
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.black),
        backgroundColor: Colors.white,
        title: Text(
          "$localNoticeCategory Notices",
          style: TextStyle(color: Colors.black),
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
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    StreamBuilder<QuerySnapshot>(
                      stream: noticeCollection
                          .orderBy('createdAt', descending: true)
                          .where(widget.noticeCategory,
                              isEqualTo: localNoticeCategory)
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
                          List<NoticeModel> noticeList = [];
                          for (var document in snapshot.data!.docs) {
                            Map<String, dynamic> data =
                                document.data()! as Map<String, dynamic>;
                            NoticeModel notice = NoticeModel.fromJson(data);
                            notice.noticeId = document.id;
                            noticeList.add(notice);
                          }

                          // print(snapshot.data!.docs.length);
                          return Expanded(
                            child: Align(
                              alignment: Alignment.topLeft,
                              child: ListView.builder(
                                shrinkWrap: true,
                                physics: BouncingScrollPhysics(),
                                itemCount: noticeList.length,
                                itemBuilder: (context, index) {
                                  NoticeModel localNotice = noticeList[index];

                                  return NoticeBubble(noticeModel: localNotice);
                                },
                              ),
                            ),
                          );
                        } else {
                          return CircularProgressIndicator();
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
