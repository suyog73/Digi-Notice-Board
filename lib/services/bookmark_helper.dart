// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:notice_board/models/user_model.dart';

// class BookmarkHelper {
//   CollectionReference studentsCollection =
//       FirebaseFirestore.instance.collection("students");

//   final String _uid = UserModel.uid.toString();

//   Future addBookmark({required noticeId}) async {
//     studentsCollection.doc(_uid).set({
//       "bookmarks": FieldValue.arrayUnion([noticeId]),
//     }, SetOptions(merge: true)).then((value) {
//       print("Notice with id $noticeId added to user collection");
//     });
//   }

//   Future deleteBookmark({required noticeId}) async {
//     studentsCollection.doc(_uid).set({
//       "bookmarks": FieldValue.arrayRemove([noticeId]),
//     }, SetOptions(merge: true)).then((value) {
//       print("Notice with id $noticeId removed successfully");
//     });
//   }
// }
