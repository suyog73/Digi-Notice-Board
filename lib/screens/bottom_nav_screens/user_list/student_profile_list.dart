// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:notice_board/helpers/constants.dart';
import 'package:notice_board/services/user_services.dart';
import 'package:notice_board/widgets/image_viewer.dart';

import '../../../models/user_model.dart';
import 'student_profile.dart';

class StudentProfileListScreen extends StatefulWidget {
  const StudentProfileListScreen({
    Key? key,
  }) : super(key: key);

  @override
  State<StudentProfileListScreen> createState() =>
      _StudentProfileListScreenState();
}

class _StudentProfileListScreenState extends State<StudentProfileListScreen> {
  String searchKey = '';

  bool resultData(List<UserModel> arr, int index, String key) {
    String name = arr[index].name.toString();
    String prn = arr[index].prn.toString();

    name = name.toLowerCase();
    prn = prn.toLowerCase();
    key = key.toLowerCase();

    if (name.contains(key) || prn.contains(key)) return true;
    return false;
  }


  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: mainColor(context),
        title: Text(
          "Student List",
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
                      cursorColor: Colors.black,
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
                    StreamBuilder<List<UserModel>>(
                      stream: StudentServices().getStudents(),
                      builder: (BuildContext context,
                          AsyncSnapshot<List<UserModel>> snapshot) {
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

                          if (snapshot.data!.isEmpty) {
                            return SizedBox(
                              height: size.height * 0.9 - 65,
                              child: Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  Text(
                                    "No Students...",
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
                            List<UserModel> studentList = snapshot.data!;

                            return Expanded(
                              child: SingleChildScrollView(
                                physics: BouncingScrollPhysics(),
                                child: Column(
                                  children: [
                                    Align(
                                      alignment: Alignment.topLeft,
                                      child: ListView.builder(
                                        shrinkWrap: true,
                                        physics: BouncingScrollPhysics(),
                                        itemCount:studentList.length,
                                        itemBuilder: (context, index) {
                                         UserModel localStudent=studentList[index];

                                          bool isValidUser = true;

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
                                                          userUid: localStudent.uid.toString(),
                                                          isCurrentUserAdmin:
                                                              true,
                                                        ),
                                                      ),
                                                    );
                                                  },
                                                  child: UserList(
                                                    prn:localStudent.prn.toString(),
                                                    name: localStudent.name.toString(),
                                                    imageUrl: localStudent.imageUrl.toString(),
                                                  ),
                                                ),
                                              );
                                            } else {
                                              return Container();
                                            }
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

class UserList extends StatelessWidget {
  const UserList({
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
              color: mainColor(context,)
            ),
          ],
        ),
      ),
    );
  }
}
