import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:notice_board/models/notice_model.dart';
import 'dart:async';

class NoticeServices {
  final CollectionReference _noticeCollection =
      FirebaseFirestore.instance.collection('notice');

  Stream<List<NoticeModel>> getNotices() {
    return _noticeCollection
        .orderBy('timestamp', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((document) =>
                NoticeModel.fromJson(document.data() as Map<String, dynamic>))
            .toList());
  }

  Future<void> addNotice(NoticeModel notice) async {
    try {
      // Generate a random ID for the new notice
      final String newNoticeId = _noticeCollection.doc().id;

      // Add the notice to the "notices" collection with the generated ID
      await _noticeCollection.doc(newNoticeId).set(notice.toJson());

      // Update the notice ID with the document ID of the newly added notice
      await _noticeCollection
          .doc(newNoticeId)
          .update({'noticeId': newNoticeId});
    } catch (e) {
      print(e.toString());
    }
  }

  Future<void> updateNotice(NoticeModel noticeModel) async {
    await _noticeCollection.doc(noticeModel.noticeId).set(
          noticeModel.toJson(),
          SetOptions(merge: true),
        );
  }

  Future<void> updateAcknowledgement(String noticeId, String userId) async {
    final DocumentReference docRef = _noticeCollection.doc(noticeId);
    final DocumentSnapshot doc = await docRef.get();

    if (!doc.exists) {
      throw Exception('Notice with id $noticeId does not exist');
    }

    final List<dynamic> acknowledgeList = doc['acknowledgeList'];
    if (!acknowledgeList.contains(userId)) {
      acknowledgeList.add(userId);
    } else {
      acknowledgeList.remove(userId);
    }
    await docRef.update({'acknowledgeList': acknowledgeList});
  }

  Future<void> updateSeen(String noticeId, String userId) async {
    final DocumentReference docRef = _noticeCollection.doc(noticeId);
    final DocumentSnapshot doc = await docRef.get();

    if (!doc.exists) {
      throw Exception('Notice with id $noticeId does not exist');
    }

    final List<dynamic> seenList = doc['seenList'];
    if (!seenList.contains(userId)) {
      seenList.add(userId);
    } else {
      seenList.remove(userId);
    }
    await docRef.update({'seenList': seenList});
  }

  Future<void> deleteNotice(String noticeId) async {
    await _noticeCollection.doc(noticeId).delete();
  }
}


// class NoticeHelper {
//   //Store User Details
//   Future<void> uploadNotice({
//     required String title,
//     String? description,
//     String? link,
//     required String year,
//     required String branch,
//     required String subject,
//     required String noticeType,
//     required String imageUrl,
//     required String pdfUrl,
//     required String owner,
//     required List<dynamic> tags,
//     bool isAdmin = true,
//     required String pdfName,
//   }) async {
//     String collectionName1 = "notice";
//     // String collectionName2 = "categories";

//     final CollectionReference noticeCollection =
//         FirebaseFirestore.instance.collection(collectionName1);

//     // final CollectionReference categoryCollection =
//     //     FirebaseFirestore.instance.collection(collectionName2);

//     FirebaseAuth auth = FirebaseAuth.instance;
//     String uid = auth.currentUser!.uid.toString();

//     // var timestamp = DateTime.now().toUtc().millisecondsSinceEpoch;

//     // String docId = "";
//     // All notices
//     await noticeCollection.add(
//       {
//         "title": title,
//         "description": description,
//         "link": link,
//         "uid": uid,
//         "isAdmin": isAdmin,
//         "subject": subject,
//         "noticeType": noticeType,
//         "imageUrl": imageUrl,
//         "pdfUrl": pdfUrl,
//         "pdfName": pdfName,
//         "owner": owner,
//         "branch": branch,
//         "year": year,
//         "tags": tags,
//         "timeStamp": DateTime.now().toUtc().millisecondsSinceEpoch,
//         "createdAt": Timestamp.now(),
//         "acknowledgeList": FieldValue.arrayUnion([]),
//         "seenList": FieldValue.arrayUnion([]),
//       },
//     ).then((value) async {
//       await noticeCollection.doc(value.id).update({'docId': value.id});
//       print("Notice Created Successfully with uid ${value.id}");
//       // docId = value.id;
//       // await storeNumberOfUsers();
//     }).catchError((error) {
//       print("Failed to add user: $error");
//     });

//     return;
//   }

//   // Update Notice
//   Future<void> updateNoticeDetails({
//     required String title,
//     String? description,
//     required String year,
//     required String branch,
//     required String subject,
//     required String noticeType,
//     required String imageUrl,
//     required String pdfUrl,
//     required String pdfName,
//     required String owner,
//     required List<dynamic> tags,
//     required String noticeId,
//     bool isAdmin = true,
//   }) async {
//     String collectionName = "notice";

//     final CollectionReference noticeCollection =
//         FirebaseFirestore.instance.collection(collectionName);

//     FirebaseAuth auth = FirebaseAuth.instance;
//     String uid = auth.currentUser!.uid.toString();

//     // print("NoticeId $noticeId");

//     noticeCollection.doc(noticeId).set({
//       "title": title,
//       "description": description,
//       "uid": uid,
//       "branch": branch,
//       "isAdmin": isAdmin,
//       "subject": subject,
//       "noticeType": noticeType,
//       "imageUrl": imageUrl == "null" ? "" : imageUrl,
//       "pdfUrl": pdfUrl == "null" ? "" : pdfUrl,
//       "pdfName": pdfName == "null" ? "" : pdfName,
//       "year": year,
//       "tags": tags,
//       "timeStamp": DateTime.now().toUtc().millisecondsSinceEpoch,
//       "createdAt": Timestamp.now(),
//     }, SetOptions(merge: true)).then((value) {
//       print("Notice Updated");
//       Fluttertoast.showToast(msg: "Notice updated Successfully");
//     }).catchError((error) {
//       print("Failed to Update user: $error");
//     });

//     return;
//   }

//   Future<void> deleteNotice(NoticeModel2 noticeModel2) async {
//     // print("noticeModel2 $noticeModel2");
//     String noticeId = noticeModel2.noticeId.toString();

//     String collectionName1 = "notice";

//     final CollectionReference noticeCollection =
//         FirebaseFirestore.instance.collection(collectionName1);
//     await noticeCollection.doc(noticeId).delete();

//     if (noticeModel2.imageUrl != "" || noticeModel2.imageUrl != null) {
//       FirebaseStorageMethods().deleteFile(noticeModel2.imageUrl);
//     }
//     if (noticeModel2.pdfUrl != "" || noticeModel2.pdfUrl != null) {
//       FirebaseStorageMethods().deleteFile(noticeModel2.pdfUrl);
//     }
//   }
// }
