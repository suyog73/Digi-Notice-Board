import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';

import '../helpers/constants.dart';
import 'get_token.dart';

class SendNotification {
  void localNotifications({
    required String noticeBranch,
    required String noticeYear,
    required String notificationMsg,
    required BuildContext context,
  }) async {
    CollectionReference _collectionRef =
        FirebaseFirestore.instance.collection('students');

    QuerySnapshot querySnapshot = await _collectionRef.get();

    final allData = querySnapshot.docs.map((doc) {
      return doc.data();
    }).toList();

    for (int i = 0; i < allData.length; i++) {
      Map<String, dynamic> _data = allData[i] as Map<String, dynamic>;

      String _noticeBranch = branches[shortBranch.indexOf(noticeBranch)];
      print(_noticeBranch);
      if (_data["Info"]["token"] != null &&
          _noticeBranch == _data["Info"]["branch"] &&
          noticeYear == _data["Info"]["year"]) {
        getToken(
          msg: notificationMsg,
          receiverUid: _data["Info"]["uid"],
          context: context,
        );
        print("Notification Send to ${_data["Info"]["name"]}");
      }
    }
  }
}
