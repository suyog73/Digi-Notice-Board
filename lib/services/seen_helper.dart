import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:notice_board/models/user_model.dart';

// class SeenHelper {
//   CollectionReference noticeCollection =
//       FirebaseFirestore.instance.collection("notice");

//   final String _uid = UserModel.uid.toString();

//   Future addSeenUserId({required noticeId}) async {
//     noticeCollection.doc(noticeId).set({
//       "seenList": FieldValue.arrayUnion([_uid]),
//     }, SetOptions(merge: true)).then((value) {
//       // print("user with id $_uid added to notice seenList collection");
//     });
//   }

  // Future deleteBookmark({required noticeId}) async {
  //   studentsCollection.doc(_uid).set({
  //     "bookmarks": FieldValue.arrayRemove([noticeId]),
  //   }, SetOptions(merge: true)).then((value) {
  //     print("Notice with id $noticeId removed successfully");
  //   });
  // }
// }
