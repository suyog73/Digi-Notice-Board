// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';

// class UserServices {
//   //Store User Details
//   Future<void> storeUserDetails({
//     required String name,
//     String? prn,
//     required String email,
//     // required String password,
//     bool isAdmin = false,
//   }) async {
//     String collectionName = isAdmin ? "admins" : "students";

//     final CollectionReference userCollection =
//         FirebaseFirestore.instance.collection(collectionName);

//     FirebaseAuth auth = FirebaseAuth.instance;
//     String uid = auth.currentUser!.uid.toString();

//     userCollection.doc(uid).set({
//       "Info": {
//         "name": name,
//         if (!isAdmin) "prn": prn.toString().toUpperCase(),
//         "email": email,
//         // "password": password,
//         "uid": uid,
//         "isAdmin": isAdmin,
//         "year": '',
//         "branch": '',
//         "club": "",
//         "imageUrl": '',
//         "category": '',
//         "timeStamp": DateTime.now().toUtc().millisecondsSinceEpoch,
//         "createdAt": Timestamp.now(),
//       }
//     }, SetOptions(merge: true)).then((value) async {
//       print("User Details Added");
//       // await storeNumberOfUsers();
//     }).catchError((error) {
//       print("Failed to add user: $error");
//     });
//     return;
//   }

//   // Store number of users
//   // Future<void> storeNumberOfUsers() async {
//   //   final CollectionReference appTotalUsersCollection =
//   //       FirebaseFirestore.instance.collection('appTotalUsers');
//   //
//   //   FirebaseAuth auth = FirebaseAuth.instance;
//   //   String uid = auth.currentUser!.uid.toString();
//   //
//   //   appTotalUsersCollection
//   //       .doc('countUser')
//   //       .set({
//   //         "userTrack": {
//   //           "count": FieldValue.increment(1),
//   //           "emails": {uid: auth.currentUser!.email}
//   //         }
//   //       }, SetOptions(merge: true))
//   //       .then((value) => print("AppTotalUser updated"))
//   //       .catchError((error) => print("Failed to update AppTotalUser $error"));
//   // }

//   // Update UserDetails
//   Future<void> updateUserDetails({
//     String? name,
//     String? year,
//     String branch = "",
//     String? club,
//     String imageUrl = "",
//     String category = "",
//     bool isAdmin = false,
//   }) async {
//     String collectionName = isAdmin ? "admins" : "students";

//     final CollectionReference userCollection =
//         FirebaseFirestore.instance.collection(collectionName);

//     FirebaseAuth auth = FirebaseAuth.instance;
//     String uid = auth.currentUser!.uid.toString();

//     userCollection
//         .doc(uid)
//         .set({
//           "Info": {
//             "name": name,
//             "year": year,
//             "club": club,
//             "branch": branch,
//             "category": category,
//             "imageUrl": imageUrl,
//           }
//         }, SetOptions(merge: true))
//         .then((value) => print("User Details Updated"))
//         .catchError((error) => print("Failed to Update user: $error"));

//     return;
//   }
// }

import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/user_model.dart';

class StudentServices {
  final CollectionReference _studentCollection =
      FirebaseFirestore.instance.collection('students');

  Stream<List<UserModel>> getStudents() {
    return _studentCollection.snapshots().map((snapshot) => snapshot.docs
        .map((doc) => UserModel.fromJson(doc.data() as Map<String, dynamic>))
        .toList());
  }

  Future<UserModel?> getStudent(String uid) async {
    try {
      final snapshot = await _studentCollection.doc(uid).get();
      if (snapshot.exists) {
        final data = snapshot.data() as Map<String, dynamic>;
        return UserModel.fromJson(data);
      }
      return null;
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  Future<void> addStudent(UserModel userModel) async {
    try {
      await _studentCollection.doc(userModel.uid).set({
        'Info': userModel.toJson(),
        'bookmarks': [],
      });
      print('Student added successfully');
    } catch (e) {
      print('Error adding student: $e');
    }
  }

  Future<void> updateStudentProperty(
      String uid, String propertyName, dynamic value) async {
    try {
      await _studentCollection.doc(uid).set(
        {
          'Info.$propertyName': value,
        },
        SetOptions(merge: true),
      );
      print('Student updated successfully');
    } catch (e) {
      print('Error updating student: $e');
    }
  }

  Future<void> updateBookmark(String uid, List<dynamic> bookmarkList) async {
    try {
      await FirebaseFirestore.instance.collection('students').doc(uid).update({
        'bookmark': bookmarkList,
      });
      print('Bookmark updated successfully.');
    } catch (error) {
      print('Failed to update bookmark: $error');
    }
  }
}

class AdminServices {
  final CollectionReference _adminCollection =
      FirebaseFirestore.instance.collection('admins');

  Stream<List<UserModel>> getAdmins() {
    return _adminCollection.snapshots().map((snapshot) => snapshot.docs
        .map((doc) => UserModel.fromJson(doc.data() as Map<String, dynamic>))
        .toList());
  }

  Future<UserModel?> getAdmin(String uid) async {
    try {
      final snapshot = await _adminCollection.doc(uid).get();
      if (snapshot.exists) {
        final data = snapshot.data() as Map<String, dynamic>;
        return UserModel.fromJson(data);
      }
      return null;
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  Future<void> addAdmin(UserModel userModel) async {
    try {
      await _adminCollection.doc(userModel.uid).set({
        'Info': userModel.toJson(),
        'bookmarks': [],
      });
      print('Admin added successfully');
    } catch (e) {
      print('Error adding student: $e');
    }
  }

  Future<void> updateAdminProperty(
      String uid, String propertyName, dynamic value) async {
    try {
      await _adminCollection.doc(uid).set(
        {
          'Info.$propertyName': value,
        },
        SetOptions(merge: true),
      );
      print('Admin updated successfully');
    } catch (e) {
      print('Error updating admin: $e');
    }
  }
}
