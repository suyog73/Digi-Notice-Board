import 'package:cloud_firestore/cloud_firestore.dart';

class TodoModel {
  String? type;
  String? myTodo;
  String? reminder;
  String? ownerUid;
  String? priority;
  String? docId;
  Timestamp? timeStamp;

  TodoModel({
    required String type,
    required String myTodo,
    required String reminder,
    required String ownerUid,
    required String priority,
    required String docId,
  });
}
