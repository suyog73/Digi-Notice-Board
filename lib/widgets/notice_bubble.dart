// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors, prefer_final_fields

import 'dart:math';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:notice_board/models/notice_model.dart';
import 'package:notice_board/models/user_model.dart';
import 'package:notice_board/providers/user_model_provider.dart';
import 'package:notice_board/screens/bottom_nav_screens/notice_detail/notice_detail_screen.dart';
import 'package:notice_board/services/timestamp_converter.dart';
import 'package:provider/provider.dart';

import '../helpers/constants.dart';
import '../providers/seen_provider.dart';
import '../services/seen_helper.dart';

class NoticeBubble extends StatefulWidget {
  const NoticeBubble({Key? key, required this.noticeModel}) : super(key: key);

  final NoticeModel noticeModel;

  @override
  State<NoticeBubble> createState() => _NoticeBubbleState();
}

class _NoticeBubbleState extends State<NoticeBubble> {
  TextStyle _textStyle = TextStyle(fontSize: 16);
  final double spacing = 8;

  // @override
  // void didChangeDependencies() {
  //   NoticeModel.seenList = widget.noticeModel.seenList;
  //   super.didChangeDependencies();
  // }

  @override
  Widget build(BuildContext context) {
    UserModel userModel =
        Provider.of<UserModelProvider>(context, listen: false).currentUser;

    String noticeTitle = widget.noticeModel.title.toString();
    int noticeTitleLength = noticeTitle.length;
    noticeTitle = noticeTitle[0].toUpperCase() + noticeTitle.substring(1);
    noticeTitle = noticeTitleLength > 6
        ? "${noticeTitle.substring(0, 6)}..."
        : noticeTitle;

    String noticeSubject = widget.noticeModel.subject.toString();
    int noticeSubjectLen = noticeSubject.length;
    noticeSubject = noticeSubject[0].toUpperCase() + noticeSubject.substring(1);
    noticeSubject = noticeSubjectLen > 7
        ? "${noticeSubject.substring(0, 7)}..."
        : noticeSubject;

    String ownerName = widget.noticeModel.ownerUid.toString()[0].toUpperCase() +
        widget.noticeModel.ownerUid.toString().substring(1);

    int ownerLen = ownerName.length;

    ownerName = ownerLen > 11 ? "${ownerName.substring(0, 11)}..." : ownerName;

    String createdTime = TimestampConverter()
        .getTimeFromTimestamp(widget.noticeModel.timeStamp!);
    String createdDate = TimestampConverter()
        .getDateFromTimestamp(widget.noticeModel.timeStamp!);

    // Size size = MediaQuery.of(context).size;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8),
      child: InkWell(
        onTap: () async {
          // if (!UserModel.isAdmin) {
          //   await SeenHelper()
          //       .addSeenUserId(noticeId: widget.noticeModel.noticeId);

          //   Provider.of<SeenProvider>(context, listen: false)
          //       .addSeen(UserModel.uid);
          // }

          if (!userModel.isAdmin) {
            SeenProvider(
                    currentUser: userModel, currentNotice: widget.noticeModel)
                .addSeen();
          }

          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) =>
                  NoticeDetailScreen(noticeModel: widget.noticeModel),
            ),
          );
        },
        child: Container(
          decoration: BoxDecoration(
            color: mainColor(context).withOpacity(0.5),
            borderRadius: BorderRadius.circular(15),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 15),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(FontAwesomeIcons.diceD6),
                        SizedBox(width: 5),
                        Text(
                          noticeTitle,
                          style: TextStyle(
                            fontSize: 25,
                            fontWeight: FontWeight.bold,
                            color: Color(0xff15133C),
                          ),
                        ),
                      ],
                    ),
                    Text(noticeSubject, style: _textStyle),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(createdDate.toString(), style: _textStyle),
                        SizedBox(height: 5),
                        Text(createdTime.toString(), style: _textStyle),
                      ],
                    )
                  ],
                ),
                SizedBox(height: 10),
                // Row(
                //   children: [],
                // ),
                buildInputChip(widget.noticeModel),
                // SizedBox(height: 10),
                SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      ownerName,
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        // color: Colors.white,
                      ),
                    ),
                    Text(
                      widget.noticeModel.year.toString(),
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        // color: Colors.white,
                      ),
                    ),
                    Text(
                      widget.noticeModel.branch.toString(),
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        // color: Colors.white,
                      ),
                    )
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  var rng = Random();

  Widget buildInputChip(NoticeModel noticeModel) => Wrap(
        runSpacing: 0,
        spacing: spacing,
        children: noticeModel.tags.map(
          (inputChip) {
            return InputChip(
              backgroundColor: Colors.white,
              label: Text(inputChip),
              labelStyle: const TextStyle(
                  fontWeight: FontWeight.bold, color: Colors.black),
              onPressed: () {},
            );
          },
        ).toList(),
      );
}
