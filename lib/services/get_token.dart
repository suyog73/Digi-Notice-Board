import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:notice_board/models/user_model.dart';
import 'package:provider/provider.dart';

import '../providers/user_model_provider.dart';

Future<void> getToken(
    {required String msg,
    required String receiverUid,
    required BuildContext context}) async {
  UserModel userModel =
      Provider.of<UserModelProvider>(context, listen: false).currentUser;

  
  User? user = FirebaseAuth.instance.currentUser;
  String uid = user!.uid;

  var _doc = await FirebaseFirestore.instance
      .collection("students")
      .doc(receiverUid)
      .get();

  var _doc1 =
      await FirebaseFirestore.instance.collection("admins").doc(uid).get();

  bool docStatus = _doc.exists;
  bool docStatus1 = _doc1.exists;

  if (docStatus == true && docStatus1 == true) {
    callOnFcmApiSendPushNotifications(
        [_doc['Info']['token']], msg, userModel.name.toString());
    // sender token, description, title

  }
}

callOnFcmApiSendPushNotifications(
    List<String> userToken, String msg, String name) async {
  // print("Notification : ${userToken[0]} $msg - $name");

  const postUrl = 'https://fcm.googleapis.com/fcm/send';
  final data = {
    "registration_ids": userToken,
    "collapse_key": "type_a",
    "notification": {
      "title": name,
      "body": msg,
    }
  };

  final headers = {
    'content-type': 'application/json',
    'Authorization': 'Bearer 	${dotenv.env['FIREBASENOTIFICATION']}'
  };

  try {
    final response = await http.post(Uri.parse(postUrl),
        body: json.encode(data),
        encoding: Encoding.getByName('utf-8'),
        headers: headers);

    if (response.statusCode == 200) {
      // on success do sth
      // print('test ok push CFM');
      return true;
    } else {
      // print(' CFM error${response.reasonPhrase}');
      // on failure do sth
      return false;
    }
  } catch (e) {
    // print('exception$e');
  }
}
