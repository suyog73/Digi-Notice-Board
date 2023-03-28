// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';
import 'package:notice_board/helpers/constants.dart';
import 'package:notice_board/screens/bottom_nav_screens/todo/create_todo.dart';
import 'package:notice_board/services/todo_helper.dart';
import 'package:notice_board/widgets/my_button.dart';

class TodoList extends StatefulWidget {
  const TodoList({Key? key}) : super(key: key);

  @override
  State<TodoList> createState() => _TodoListState();
}

class _TodoListState extends State<TodoList> {
  CollectionReference todoCollection =
      FirebaseFirestore.instance.collection("todo");

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: mainColor(context),
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "My Todo List",
              style: TextStyle(color: textColor(context)),
            ),
            InkWell(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => CreateTodo(),
                  ),
                );
              },
              child: Icon(
                Icons.add_box_outlined,
                color: Colors.black,
                size: 32,
              ),
            )
          ],
        ),
      ),
      body: SizedBox(
        width: size.width,
        child: Padding(
          padding: const EdgeInsets.only(top: 18.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    StreamBuilder<QuerySnapshot>(
                      stream: todoCollection
                          .orderBy('createdAt', descending: true)
                          .snapshots(),
                      builder: (BuildContext context,
                          AsyncSnapshot<QuerySnapshot> snapshot) {
                        if (!snapshot.hasData) {
                          return Expanded(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                CircularProgressIndicator(color: mainColor(context)),
                              ],
                            ),
                          );
                        }

                        if (snapshot.data != null && snapshot.hasData) {
                          print(snapshot.data!.docs.length);
                          print("Hello");

                          if (snapshot.data!.docs.isEmpty) {
                            return SizedBox(
                              height: size.height * 0.9 - 65,
                              child: Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  Text(
                                    "Nothing to show here...",
                                    style: TextStyle(fontSize: 28),
                                  ),
                                  Lottie.asset(
                                    'assets/lottie/all.json',
                                    fit: BoxFit.fill,
                                  ),
                                  SizedBox(height: size.height * 0.05),
                                ],
                              ),
                            );
                          } else {
                            return Expanded(
                              child: Align(
                                alignment: Alignment.topLeft,
                                child: ListView.builder(
                                  shrinkWrap: true,
                                  physics: BouncingScrollPhysics(),
                                  itemCount: snapshot.data!.docs.length,
                                  itemBuilder: (context, index) {
                                    Map<String, dynamic> data =
                                        snapshot.data!.docs[index].data()
                                            as Map<String, dynamic>;

                                    String deadlineDate = DateFormat.yMMMd()
                                        .format(data['reminder'].toDate());

                                    String deadlineTime = DateFormat.jm()
                                        .format(data['reminder']
                                            .toDate()); //17:08  force 24 hour time

                                    return Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 18.0, vertical: 8),
                                      child: InkWell(
                                        onLongPress: () async {
                                          await TodoHelper().deleteTodo(
                                              todoUid: data['docId']);
                                        },
                                        onTap: () {
                                          showDialog(
                                            context: context,
                                            builder: (context) => AlertDialog(
                                              title: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  SizedBox(
                                                    width: size.width * 0.45,
                                                    child: Text(data['type']),
                                                  ),
                                                  InkWell(
                                                    onTap: () {
                                                      Navigator.push(
                                                        context,
                                                        MaterialPageRoute(
                                                          builder: (context) =>
                                                              CreateTodo(
                                                            myTodo:
                                                                data['myTodo'],
                                                            type: data['type'],
                                                          ),
                                                        ),
                                                      );
                                                    },
                                                    child: Icon(Icons.edit,
                                                        color: mainColor(context)),
                                                  ),
                                                ],
                                              ),
                                              content: SizedBox(
                                                width: size.width * 0.4,
                                                height: size.height * 0.2,
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        Text(data['myTodo']),
                                                        SizedBox(height: 10),
                                                        PriorityTag(data: data),
                                                      ],
                                                    ),
                                                    Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        Text(
                                                          "Deadline",
                                                          style: TextStyle(
                                                            fontSize: 18,
                                                            color: Colors.red,
                                                          ),
                                                        ),
                                                        SizedBox(height: 5),
                                                        Text(deadlineDate),
                                                        Text(deadlineTime),
                                                      ],
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              actions: [
                                                InkWell(
                                                  onTap: () {
                                                    Navigator.pop(context);
                                                  },
                                                  child: MyButton1(
                                                    text: 'Ok',
                                                    color: mainColor(context),
                                                    borderRadius: 5,
                                                    textColor: textColor(context),
                                                    width: size.width * .2,
                                                    height: 35,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          );
                                        },
                                        child: Container(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 18.0, vertical: 10),
                                          decoration: BoxDecoration(
                                            color: Colors.white,
                                            border: Border.all(
                                              color: Colors.black,
                                            ),
                                            borderRadius:
                                                BorderRadius.circular(5),
                                            boxShadow: [
                                              BoxShadow(
                                                color: Colors.grey
                                                    .withOpacity(0.4),
                                                spreadRadius: 5,
                                                blurRadius: 7,
                                                offset: Offset(0,
                                                    3), // changes position of shadow
                                              ),
                                            ],
                                          ),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    data['type'],
                                                    style:
                                                        TextStyle(fontSize: 20),
                                                  ),
                                                  SizedBox(height: 5),
                                                  Text(
                                                    data['myTodo'],
                                                    style:
                                                        TextStyle(fontSize: 16),
                                                  ),
                                                ],
                                              ),
                                              PriorityTag(data: data),
                                            ],
                                          ),
                                        ),
                                      ),
                                    );
                                  },
                                ),
                              ),
                            );
                          }
                        } else {
                          return Container();
                        }
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class PriorityTag extends StatelessWidget {
  const PriorityTag({
    Key? key,
    required this.data,
  }) : super(key: key);

  final Map<String, dynamic> data;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 0.0),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        decoration: BoxDecoration(
          color: tagColor[data['priority']],
          borderRadius: BorderRadius.circular(5),
        ),
        child: Text(data['priority']),
      ),
    );
  }
}
