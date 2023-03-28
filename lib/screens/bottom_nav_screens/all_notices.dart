// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:notice_board/helpers/constants.dart';
import 'package:notice_board/services/notice_services.dart';
import 'package:notice_board/widgets/my_appbar.dart';
  
import '../../models/notice_model.dart';
import '../../widgets/notice_bubble.dart';

class AllNotices extends StatefulWidget {
  const AllNotices({Key? key}) : super(key: key);

  @override
  State<AllNotices> createState() => _AllNoticesState();
}

class _AllNoticesState extends State<AllNotices> {
  CollectionReference noticeCollection =
      FirebaseFirestore.instance.collection("notice");

  @override
  Widget build(BuildContext context) {
    Color mainColor2 = mainColor(context);
    Size size = MediaQuery.of(context).size;

    return Scaffold(
      // backgroundColor: kBackGroundColor,
      appBar: MyAppBar(
        appBarName: 'All Notices',
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
                    StreamBuilder<List<NoticeModel>>(
                      stream: NoticeServices().getNotices(),
                      builder: (BuildContext context,
                          AsyncSnapshot<List<NoticeModel>> snapshot) {
                        if (!snapshot.hasData) {
                          return Expanded(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                CircularProgressIndicator(color: mainColor2),
                              ],
                            ),
                          );
                        }

                        if (snapshot.data != null && snapshot.hasData) {
                          // print(snapshot.data!.docs.length);

                          if (snapshot.data!.isEmpty) {
                            return SizedBox(
                              height: size.height * 0.9 - 65,
                              child: Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  Text(
                                    "Nothing to show here...",
                                    style: TextStyle(fontSize: 28),
                                  ),
                                  Lottie.asset(
                                    'assets/lottie/all.json',
                                    fit: BoxFit.fill,
                                  ),
                                  SizedBox(height: size.height * 0.05),
                                ],
                              ),
                            );
                          } else {
                            return Expanded(
                              child: Align(
                                alignment: Alignment.topLeft,
                                child: ListView.builder(
                                  shrinkWrap: true,
                                  physics: BouncingScrollPhysics(),
                                  itemCount: snapshot.data!.length,
                                  itemBuilder: (context, index) {
                                    NoticeModel noticeModel =
                                        snapshot.data![index];

                                    // String sendAt = data['createdAt']
                                    //     .toDate()
                                    //     .toString()
                                    //     .substring(11, 16);

                                    // String createdDate = DateFormat.yMMMd()
                                    //     .format(data['createdAt'].toDate());

                                    // return NoticeBubble(
                                    //   noticeModel2: NoticeModel2(
                                    //     title: data['title'],
                                    //     description: data['description'],
                                    //     link: data['link'],
                                    //     subject: data['subject'],
                                    //     noticeType: data['noticeType'],
                                    //     imageUrl: data['imageUrl'],
                                    //     pdfUrl: data['pdfUrl'],
                                    //     pdfName: data['pdfName'],
                                    //     createdAt: sendAt,
                                    //     createdDate: createdDate,
                                    //     year: data['year'],
                                    //     branch: data['branch'],
                                    //     owner: data['owner'],
                                    //     tags: data['tags'],
                                    //     noticeId: data['docId'],
                                    //     ownerUid: data['uid'],
                                    //     acknowledgeList:
                                    //         data['acknowledgeList'],
                                    //     seenList: data['seenList'],
                                    //   ),
                                    // );
                                    return NoticeBubble(noticeModel: noticeModel);
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
