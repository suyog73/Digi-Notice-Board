// ignore_for_file: prefer_const_constructors

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:notice_board/helpers/constants.dart';
import 'package:notice_board/models/notice_model.dart';
import 'package:notice_board/screens/bottom_nav_screens/user_list/student_profile.dart';
import 'package:notice_board/widgets/image_viewer.dart';

class AckScreen extends StatefulWidget {
  const AckScreen({
    Key? key,
    required this.title,
    required this.noticeModel,
    required this.isSeen,
  }) : super(key: key);

  @override
  State<AckScreen> createState() => _AckScreenState();

  final String title;
  final NoticeModel noticeModel;
  final bool isSeen;
}

class _AckScreenState extends State<AckScreen> {
  String searchKey = '';

  bool resultData(List arr, int index, String _key) {
    String name = arr[index]['Info']['name'];
    String prn = arr[index]['Info']['prn'];

    name = name.toLowerCase();
    prn = prn.toLowerCase();
    _key = _key.toLowerCase();

    if (name.contains(_key) || prn.contains(_key)) return true;
    return false;
  }

  CollectionReference studentsCollection =
      FirebaseFirestore.instance.collection("students");

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: mainColor(context),
        title: Text(
          "${widget.noticeModel.title} : ${widget.title}",
          style: TextStyle(
            color: Colors.black,
            fontSize: 22,
          ),
        ),
        iconTheme: IconThemeData(color: Colors.black),
      ),
      body: SizedBox(
        width: size.width,
        child: Padding(
          padding: const EdgeInsets.only(top: 18.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 32)
                    .copyWith(top: 10),
                child: Stack(
                  children: [
                    Container(
                      height: 54,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(7),
                        color: Colors.grey.shade100,
                        border: Border.all(
                            color: Colors.grey.shade700.withOpacity(0.15)),
                      ),
                    ),
                    TextFormField(
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 16,
                      ),
                      decoration: kTextFormFieldAuthDec.copyWith(
                        hintText: 'Search Student',
                        prefixIcon: Icon(Icons.search, color: mainColor(context)),
                        prefixIconColor: Colors.red,
                        errorStyle: TextStyle(color: kGreenShadeColor),
                      ),
                      textInputAction: TextInputAction.done,
                      cursorColor: Colors.grey.shade200,
                      onChanged: (val) {
                        setState(() {
                          searchKey = val;
                        });
                      },
                    ),
                  ],
                ),
              ),
              SizedBox(height: 20),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    StreamBuilder<QuerySnapshot>(
                      stream: studentsCollection.snapshots(),
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
                          // print(snapshot.data!.docs.length);

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
                            final studentList = snapshot.data!.docs;

                            final noOfStudents = widget.isSeen
                                ? widget.noticeModel.seenList.length
                                : widget.noticeModel.acknowledgeList.length;
                            String std =
                                noOfStudents == 1 ? "Student" : "Students";

                            String type =
                                widget.isSeen ? "seen" : "acknowledge";
                            return Expanded(
                              child: SingleChildScrollView(
                                child: Column(
                                  children: [
                                    Center(
                                      child: Text(
                                        "$noOfStudents $std $type this notice",
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                          fontSize: 20,
                                        ),
                                      ),
                                    ),
                                    SizedBox(height: 10),
                                    Align(
                                      alignment: Alignment.topLeft,
                                      child: ListView.builder(
                                        shrinkWrap: true,
                                        physics: BouncingScrollPhysics(),
                                        itemCount: snapshot.data!.docs.length,
                                        itemBuilder: (context, index) {
                                          Map<String, dynamic> data =
                                              snapshot.data!.docs[index].data()
                                                  as Map<String, dynamic>;
                                          String userUids = data["Info"]["uid"];
                                          // print("userUid $userUids");

                                          bool isValidUser = widget.isSeen
                                              ? widget.noticeModel.seenList
                                                  .contains(userUids)
                                              : widget
                                                  .noticeModel.acknowledgeList
                                                  .contains(userUids);

                                          if (isValidUser) {
                                            if (resultData(studentList, index,
                                                searchKey)) {
                                              return Padding(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        vertical: 2.0,
                                                        horizontal: 10),
                                                child: InkWell(
                                                  onTap: () {
                                                    Navigator.of(context).push(
                                                      MaterialPageRoute(
                                                        builder: (context) =>
                                                            StudentProfile(
                                                          userUid: data["Info"]
                                                              ["uid"],
                                                          isCurrentUserAdmin:
                                                              false,
                                                        ),
                                                      ),
                                                    );
                                                  },
                                                  child: SeenAckBlock(
                                                    prn: data["Info"]["prn"],
                                                    name: data["Info"]["name"],
                                                    imageUrl: data["Info"]
                                                        ["imageUrl"],
                                                  ),
                                                ),
                                              );
                                            } else {
                                              return Container();
                                            }
                                          } else {
                                            return Container();
                                          }
                                        },
                                      ),
                                    ),
                                  ],
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

class SeenAckBlock extends StatelessWidget {
  const SeenAckBlock({
    Key? key,
    required this.imageUrl,
    required this.name,
    required this.prn,
  }) : super(key: key);

  final String imageUrl, name, prn;

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
        side: BorderSide(
          color: Colors.grey.withOpacity(0.8),
          width: 1,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 5),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                ImageViewer2(width: 60, height: 60, imageUrl: imageUrl),
                SizedBox(width: 20),
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      name,
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                    ),
                    SizedBox(height: 5),
                    Text(
                      prn,
                      style: TextStyle(fontSize: 16),
                    ),
                  ],
                ),
              ],
            ),
            Icon(
              Icons.send,
              size: 25,
              color: mainColor(context),
            ),
          ],
        ),
      ),
    );
  }
}
