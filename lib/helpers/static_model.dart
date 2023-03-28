import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:notice_board/models/user_model.dart';

import '../models/notice_model.dart';

UserModel staticUser = UserModel(
  name: "Suyog Patil",
  prn: "2020BTEIT00043",
  email: "suyog.patil@walchandsangli.ac.in",
  imageUrl: "imageUrl",
  year: "Third Year",
  passOutYear: "2024",
  adminCategory: "Dean",
  branch: "Information Technology",
  uid: "uid",
  bookmarkNotices: [],
  isAdmin: false,
);

NoticeModel staticNotice = NoticeModel(
  title: "Example Title",
  description: "Example Description",
  link: "https://example.com",
  subject: "Example Subject",
  year: "Third Year",
  branch: "Information Technology",
  ownerUid: "123",
  noticeType: "",
  noticeId: "123",
  pdfName: "",
  timeStamp: Timestamp.now(),
);
