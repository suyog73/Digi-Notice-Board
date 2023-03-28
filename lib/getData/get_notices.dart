// // ignore_for_file: prefer_const_constructors
//
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
//
// class GetNoticeCat extends StatelessWidget {
//   const GetNoticeCat({Key? key, this.isRequire = false}) : super(key: key);
//
//   final bool isRequire;
//
//   @override
//   Widget build(BuildContext context) {
//     FirebaseAuth auth = FirebaseAuth.instance;
//     String uid = auth.currentUser!.uid.toString();
//
//     CollectionReference followerCollection =
//         FirebaseFirestore.instance.collection('categories');
//     return Scaffold(
//       body: FutureBuilder<DocumentSnapshot>(
//         future: followerCollection
//             .doc("branch")
//             .collection("CSE")
//             .doc("branch")
//             .get(),
//         builder:
//             (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
//           if (snapshot.hasError) {
//             return Center(
//               child: Text(
//                 'Something went wrong, Please try again',
//               ),
//             );
//           }
//           if (snapshot.hasData && !snapshot.data!.exists) {
//             // print(UserModel.followers);
//             //
//             // return isRequire ? FollowersScreen() : BottomNavigation();
//           }
//           if (snapshot.connectionState == ConnectionState.done) {
//             Map<String, dynamic> data =
//                 snapshot.data!.data() as Map<String, dynamic>;
//             print('follower list');
//             print(data['follower']);
//
//             UserModel.followers = data['follower'];
//
//             return isRequire ? FollowersScreen() : BottomNavigation();
//           }
//           return Center(
//             child: CircularProgressIndicator(color: kGreenShadeColor),
//           );
//         },
//       ),
//     );
//   }
// }
