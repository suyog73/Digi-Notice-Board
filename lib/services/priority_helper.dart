// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:notice_board/models/user_model.dart';

// class PriorityHelper {
//   CollectionReference studentsCollection =
//       FirebaseFirestore.instance.collection("students");

//   final String _uid = UserModel.uid.toString();

//   // Priority 1
//   Future addPriority({required noticeId, required double priority}) async {
//     String arrayName = "Priority1";

//     if (priority == 2) arrayName = "Priority2";
//     if (priority == 3) arrayName = "Priority3";
//     if (priority == 4) arrayName = "Priority4";
//     if (priority == 5) arrayName = "Priority5";

//     studentsCollection.doc(_uid).set({
//       arrayName: FieldValue.arrayUnion([noticeId]),
//     }, SetOptions(merge: true)).then((value) {
//       print(
//           "Notice with id $noticeId added to user collection with $arrayName");
//     });
//   }

//   Future deletePriority({required noticeId, required double priority}) async {
//     if (priority == -1) return;

//     String arrayName = "Priority1";

//     if (priority == 2) arrayName = "Priority2";
//     if (priority == 3) arrayName = "Priority3";
//     if (priority == 4) arrayName = "Priority4";
//     if (priority == 5) arrayName = "Priority5";

//     studentsCollection.doc(_uid).set({
//       arrayName: FieldValue.arrayRemove([noticeId]),
//     }, SetOptions(merge: true)).then((value) {
//       print("Notice with id $noticeId removed successfully with $arrayName");
//     });
//   }
//   //
//   // // Priority 2
//   // Future addPriority2({required noticeId}) async {
//   //   studentsCollection.doc(_uid).set({
//   //     "Priority2": FieldValue.arrayUnion([noticeId]),
//   //   }, SetOptions(merge: true)).then((value) {
//   //     print(
//   //         "Notice with id $noticeId added to user collection with priority 2");
//   //   });
//   // }
//   //
//   // // Priority 3
//   // Future addPriority3({required noticeId}) async {
//   //   studentsCollection.doc(_uid).set({
//   //     "Priority3": FieldValue.arrayUnion([noticeId]),
//   //   }, SetOptions(merge: true)).then((value) {
//   //     print(
//   //         "Notice with id $noticeId added to user collection with priority 3");
//   //   });
//   // }
//   //
//   // // Priority 4
//   // Future addPriority4({required noticeId}) async {
//   //   studentsCollection.doc(_uid).set({
//   //     "Priority4": FieldValue.arrayUnion([noticeId]),
//   //   }, SetOptions(merge: true)).then((value) {
//   //     print(
//   //         "Notice with id $noticeId added to user collection with priority 4");
//   //   });
//   // }
//   //
//   // // Priority 5
//   // Future addPriority5({required noticeId}) async {
//   //   studentsCollection.doc(_uid).set({
//   //     "Priority5": FieldValue.arrayUnion([noticeId]),
//   //   }, SetOptions(merge: true)).then((value) {
//   //     print(
//   //         "Notice with id $noticeId added to user collection with priority 5");
//   //   });
//   // }

//   //
//   // Future deletePriority2({required noticeId}) async {
//   //   studentsCollection.doc(_uid).set({
//   //     "Priority2": FieldValue.arrayRemove([noticeId]),
//   //   }, SetOptions(merge: true)).then((value) {
//   //     print("Notice with id $noticeId removed successfully");
//   //   });
//   // }
//   //
//   // Future deletePriority3({required noticeId}) async {
//   //   studentsCollection.doc(_uid).set({
//   //     "Priority3": FieldValue.arrayRemove([noticeId]),
//   //   }, SetOptions(merge: true)).then((value) {
//   //     print("Notice with id $noticeId removed successfully");
//   //   });
//   // }
//   //
//   // Future deletePriority4({required noticeId}) async {
//   //   studentsCollection.doc(_uid).set({
//   //     "Priority4": FieldValue.arrayRemove([noticeId]),
//   //   }, SetOptions(merge: true)).then((value) {
//   //     print("Notice with id $noticeId removed successfully");
//   //   });
//   // }
//   //
//   // Future deletePriority5({required noticeId}) async {
//   //   studentsCollection.doc(_uid).set({
//   //     "Priority5": FieldValue.arrayRemove([noticeId]),
//   //   }, SetOptions(merge: true)).then((value) {
//   //     print("Notice with id $noticeId removed successfully");
//   //   });
//   // }
// }
