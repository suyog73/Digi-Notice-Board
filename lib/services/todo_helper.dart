import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class TodoHelper {
  //Store User Details
  Future<void> storeTodoDetails({
    required String myTodo,
    required String type,
    required String priority,
    required DateTime reminder,
  }) async {
    final CollectionReference todoCollection =
        FirebaseFirestore.instance.collection("todo");

    FirebaseAuth auth = FirebaseAuth.instance;
    String uid = auth.currentUser!.uid.toString();

    todoCollection.add(
      {
        "myTodo": myTodo,
        "ownerUid": uid,
        "type": type,
        "reminder": reminder,
        "priority": priority,
        "timeStamp": DateTime.now().toUtc().millisecondsSinceEpoch,
        "createdAt": Timestamp.now(),
      },
    ).then((value) async {
      await todoCollection.doc(value.id).update({'docId': value.id});

      print("Todo Added");
      // await storeNumberOfUsers();
    }).catchError((error) {
      print("Failed to add todo: $error");
    });
    return;
  }

  Future<void> updateTodoDetails({
    required String myTodo,
    required String type,
    required DateTime reminder,
    required String priority,
  }) async {
    final CollectionReference todoCollection =
        FirebaseFirestore.instance.collection("todo");

    FirebaseAuth auth = FirebaseAuth.instance;
    String uid = auth.currentUser!.uid.toString();

    todoCollection
        .doc(uid)
        .set({
          "Info": {
            "myTodo": myTodo,
            "type": type,
            "reminder": reminder,
            "priority": priority,
          }
        }, SetOptions(merge: true))
        .then((value) => print("Todo Updated"))
        .catchError((error) => print("Failed to Update todo: $error"));

    return;
  }

  Future<void> deleteTodo({required String todoUid}) async {
    // print("noticeModel2 $noticeModel2");

    String collectionName1 = "todo";

    final CollectionReference todoCollection =
        FirebaseFirestore.instance.collection(collectionName1);

    await todoCollection.doc(todoUid).delete();
  }
}
