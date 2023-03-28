// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:notice_board/helpers/constants.dart';
import 'package:provider/provider.dart';

import '../models/notice_model.dart';
import '../providers/bookmark_provider.dart';

class MyBookmark extends StatefulWidget {
  const MyBookmark({
    Key? key,
    required this.noticeModel,
  }) : super(key: key);

  final NoticeModel noticeModel;

  @override
  State<MyBookmark> createState() => _MyBookmarkState();
}

class _MyBookmarkState extends State<MyBookmark> {
  bool _isBookmark = true;

  @override
  Widget build(BuildContext context) {
    BookmarkProvider bookmarkProvider =
        Provider.of<BookmarkProvider>(context, listen: false);
    _isBookmark =
        bookmarkProvider.isBookmark(widget.noticeModel.noticeId.toString());

    return Padding(
      padding: const EdgeInsets.only(right: 18.0),
      child: InkWell(
        onTap: () async {
          setState(() {
            _isBookmark = !_isBookmark;
          });

          if (_isBookmark) {
            // await BookmarkHelper()
            //     .addBookmark(noticeId: widget.noticeModel.noticeId);

            bookmarkProvider
                .addBookmark(widget.noticeModel.noticeId.toString());

            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                duration: Duration(seconds: 1),
                backgroundColor: mainColor(context),
                content: Text(
                  'Bookmark added Successfully',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            );
          } else {
            // await BookmarkHelper()
            //     .deleteBookmark(noticeId: widget.noticeModel.noticeId);

            bookmarkProvider
                .deleteBookmark(widget.noticeModel.noticeId.toString());

            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                duration: Duration(seconds: 1),
                backgroundColor: Colors.redAccent,
                content: Text(
                  'Bookmark removed Successfully',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            );
          }
        },
        child: Icon(
          _isBookmark
              ? FontAwesomeIcons.solidBookmark
              : FontAwesomeIcons.bookmark,
          color: Colors.white,
        ),
      ),
    );
  }
}
