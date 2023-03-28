// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:notice_board/widgets/my_appbar.dart';

import '../../../helpers/constants.dart';
import 'category_wise_notice.dart';

class NoticeTypeScreen extends StatelessWidget {
  const NoticeTypeScreen({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MyAppBar(appBarName: 'Select Notice Type'),
      body: ListView.builder(
        itemCount: noticeType.length,
        itemBuilder: (context, idx) => Padding(
          padding:
              const EdgeInsets.symmetric(horizontal: 18.0).copyWith(top: 18),
          child: InkWell(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => CategoryWiseNotice(
                    noticeCategory: "noticeType",
                    noticeCategory2: noticeType[idx],
                  ),
                ),
              );
            },
            child: Container(
              padding: const EdgeInsets.all(18.0),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),
                border: Border.all(color: mainColor(context), width: 2),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    noticeType[idx],
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.w600),
                  ),
                  Icon(Icons.arrow_forward_ios_outlined)
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
