// // Used while creating notice

// class NoticeModel1 {
//   static String? title;
//   static String? description;
//   static String? link;
//   static String? subject;
//   static String? year;
//   static String? branch;
//   static String? ownerUid;
//   static String? noticeType;
//   static String imageUrl = "";
//   static String pdfUrl = "";
//   static String? noticeId;
//   static String? pdfName;
//   static List<dynamic> seenList = [];
//   static List<dynamic> acknowledgeList = [];
//   static List<dynamic> tags = [];
// }

// // Used while displaying the notice
// class NoticeModel2 {
//   String? title;
//   String? description;
//   String? link;
//   String? subject;
//   String? noticeType;
//   String? imageUrl;
//   String? pdfUrl;
//   List<dynamic> tags = [];
//   String? createdAt;
//   String? year;
//   String? branch;
//   String? ownerUid;
//   String? ownerUid;
//   String? noticeId;
//   String? createdDate;
//   String? pdfName;
//   List<dynamic> seenList = [];
//   List<dynamic> acknowledgeList = [];

//   NoticeModel2({
//     required this.title,
//     required this.description,
//     this.link,
//     required this.subject,
//     required this.noticeType,
//     required this.imageUrl,
//     required this.pdfUrl,
//     required this.createdAt,
//     required this.tags,
//     required this.branch,
//     required this.ownerUid,
//     required this.year,
//     required this.noticeId,
//     required this.createdDate,
//     required this.ownerUid,
//     required this.pdfName,
//     required this.seenList,
//     required this.acknowledgeList,
//   });
// }

// class YearCat {
//   static List<dynamic> firstYear = [];
//   static List<dynamic> secondYear = [];
//   static List<dynamic> thirdYear = [];
//   static List<dynamic> finalYear = [];
// }

// class BranchCat {
//   static List<dynamic> cse = [];
//   static List<dynamic> it = [];
//   static List<dynamic> entc = [];
//   static List<dynamic> ele = [];
//   static List<dynamic> mech = [];
//   static List<dynamic> civil = [];
// }

// class SubjectCat {
//   static List<dynamic> ca = [];
//   static List<dynamic> cn = [];
//   static List<dynamic> toc = [];
//   static List<dynamic> se = [];
//   static List<dynamic> java = [];
//   static List<dynamic> android = [];
// }

// class NoticeTypeCat {
//   static List<dynamic> general = [];
//   static List<dynamic> holiday = [];
//   static List<dynamic> exam = [];
//   static List<dynamic> lecture = [];
//   static List<dynamic> assignment = [];
// }

// class OwnerCat {
//   static List<dynamic> noticesUid = [];
// }

import 'package:cloud_firestore/cloud_firestore.dart';

class NoticeModel {
  String? title;
  String? description;
  String? link;
  String? subject;
  String? year;
  String? branch;
  String? ownerUid;
  String? noticeType;
  String imageUrl = "";
  String pdfUrl = "";
  String? noticeId;
  String? pdfName;
  Timestamp? timeStamp;
  List<dynamic> seenList = [];
  List<dynamic> acknowledgeList = [];
  List<dynamic> tags = [];

  NoticeModel({
    required this.title,
    required this.description,
    required this.link,
    required this.subject,
    required this.year,
    required this.branch,
    required this.ownerUid,
    required this.noticeType,
    this.imageUrl = "",
    this.pdfUrl = "",
    required this.noticeId,
    required this.pdfName,
    required this.timeStamp,
    this.seenList = const [],
    this.acknowledgeList = const [],
    this.tags = const [],
  });

  factory NoticeModel.fromJson(Map<String, dynamic> json) {
    return NoticeModel(
        title: json['title'],
        description: json['description'],
        link: json['link'],
        subject: json['subject'],
        year: json['year'],
        branch: json['branch'],
        ownerUid: json['ownerUid'],
        noticeType: json['noticeType'],
        imageUrl: json['imageUrl'] ?? "",
        pdfUrl: json['pdfUrl'] ?? "",
        noticeId: json['noticeId'],
        pdfName: json['pdfName'],
        seenList: json['seenList'] ?? [],
        acknowledgeList: json['acknowledgeList'] ?? [],
        tags: json['tags'] ?? [],
        timeStamp: json['timestamp']);
  }

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'description': description,
      'link': link,
      'subject': subject,
      'year': year,
      'branch': branch,
      'ownerUid': ownerUid,
      'noticeType': noticeType,
      'imageUrl': imageUrl,
      'pdfUrl': pdfUrl,
      'noticeId': noticeId,
      'pdfName': pdfName,
      'seenList': seenList,
      'acknowledgeList': acknowledgeList,
      'tags': tags,
      'timestamp': timeStamp,
    };
  }
}
