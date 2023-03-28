// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:notice_board/helpers/constants.dart';
import 'package:notice_board/models/notice_model.dart';
import 'package:notice_board/providers/user_model_provider.dart';
import 'package:notice_board/services/notice_services.dart';
import 'package:notice_board/widgets/my_appbar.dart';
import 'package:provider/provider.dart';

import '../../models/user_model.dart';
import '../../widgets/notice_bubble.dart';

class BookmarkNotices extends StatefulWidget {
  const BookmarkNotices({Key? key}) : super(key: key);

  @override
  State<BookmarkNotices> createState() => _BookmarkNoticesState();
}

class _BookmarkNoticesState extends State<BookmarkNotices> {
  @override
  Widget build(BuildContext context) {
    UserModel userModel =
        Provider.of<UserModelProvider>(context, listen: false).currentUser;

    Size size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: MyAppBar(
        appBarName: 'Bookmark',
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
                                CircularProgressIndicator(
                                    color: mainColor(context)),
                              ],
                            ),
                          );
                        }
                        if (snapshot.data != null && snapshot.hasData) {
                          List<NoticeModel> noticeList = snapshot.data!;

                          return Expanded(
                            child: Align(
                              alignment: Alignment.topLeft,
                              child: ListView.builder(
                                shrinkWrap: true,
                                physics: BouncingScrollPhysics(),
                                itemCount: noticeList.length,
                                itemBuilder: (context, index) {
                                  NoticeModel localNotice = noticeList[index];

                                  if (userModel.bookmarkNotices
                                      .contains(localNotice.noticeId)) {
                                    return NoticeBubble(
                                        noticeModel: localNotice);

                                    // var timestamp = data['timestamp'];

                                    // return NoticeBubble(
                                    //   noticeModel: NoticeModel2(
                                    //     title: data['title'],
                                    //     description: data['description'],
                                    //     link: data['link'],
                                    //     subject: data['subject'],
                                    //     noticeType: data['noticeType'],
                                    //     imageUrl: data['imageUrl'],
                                    //     pdfUrl: data['pdfUrl'],
                                    //     createdAt: sendAt,
                                    //     createdDate: createdDate,
                                    //     year: data['year'],
                                    //     branch: data['branch'],
                                    //     ownerUid: data['owner'],
                                    //     tags: data['tags'],
                                    //     noticeId: data['docId'],
                                    //     ownerUid: data['uid'],
                                    //     pdfName: data['pdfName'],
                                    //     acknowledgeList:
                                    //         data['acknowledgeList'],
                                    //     seenList: data['seenList'],
                                    //   ),
                                    // );
                                  } else {
                                    return Container();
                                  }
                                },
                              ),
                            ),
                          );
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
