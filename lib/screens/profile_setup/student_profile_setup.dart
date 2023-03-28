// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:notice_board/helpers/constants.dart';
import 'package:notice_board/models/user_model.dart';
import 'package:path/path.dart' as path;
import 'package:provider/provider.dart';
import '../../providers/user_model_provider.dart';
import '../../services/auth_helper.dart';
import '../../services/firebase_upload.dart';
import '../../services/get_student_data.dart';
import '../../widgets/my_button.dart';

class StudentProfileSetup extends StatefulWidget {
  const StudentProfileSetup({Key? key}) : super(key: key);

  @override
  _StudentProfileSetupState createState() => _StudentProfileSetupState();
}

class _StudentProfileSetupState extends State<StudentProfileSetup> {
  FirebaseAuth auth = FirebaseAuth.instance;

  final GlobalKey<FormState> _formFieldKey = GlobalKey<FormState>();

  // image source
  File? _image;

  // upload task
  UploadTask? task;

  String urlDownload =
      'https://thumbs.dreamstime.com/b/solid-purple-gradient-user-icon-web-mobile-design-interface-ui-ux-developer-app-137467998.jpg';

  bool showSpinner = false;
  String? selectedYear;
  String? selectedBranch;

  void uploadData() async {
    setState(() {
      showSpinner = true;
    });

    Provider.of<UserModelProvider>(context, listen: false)
        .updateUserProperty("year", selectedYear ?? "");
    Provider.of<UserModelProvider>(context, listen: false)
        .updateUserProperty("branch", selectedBranch ?? "");

    // setState(() {
    //   UserModel.year = selectedYear ?? "";
    //   UserModel.branch = selectedBranch ?? "";
    // });

    await uploadImage().then((value) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => GetStudentData(),
        ),
      );
    });
    // await UserServices().updateUserDetails(
    //   name: UserModel.name,
    //   branch: selectedBranch.toString(),
    //   year: selectedYear.toString(),
    //   category: "",
    //   imageUrl: urlDownload,
    //   isAdmin: false,
    // );
  }

  void showErrorMsg() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: kVioletShade,
        content: Text(
          'All Fields are mandatory',
          style: TextStyle(color: Colors.white),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // Size size = MediaQuery.of(context).size;
    DropdownMenuItem<String> buildMenuYear(String year) => DropdownMenuItem(
          value: year,
          child: Row(
            children: [
              Icon(FontAwesomeIcons.calendar, color: kVioletShade),
              SizedBox(width: 10),
              Text(year),
            ],
          ),
        );
    DropdownMenuItem<String> buildMenuBranch(String branch) => DropdownMenuItem(
          value: branch,
          child: Row(
            children: [
              Icon(FontAwesomeIcons.codeBranch, color: kVioletShade),
              SizedBox(width: 10),
              Text(branch),
            ],
          ),
        );
    // DropdownMenuItem<String> buildMenuClub(String club) => DropdownMenuItem(
    //       value: club,
    //       child: Row(
    //         children: [
    //           Icon(FontAwesomeIcons.handPeace, color: kVioletShade),
    //           SizedBox(width: 10),
    //           Text(club),
    //         ],
    //       ),
    //     );

    return SafeArea(
      child: ModalProgressHUD(
        inAsyncCall: showSpinner,
        progressIndicator: CircularProgressIndicator(color: kVioletShade),
        child: WillPopScope(
          onWillPop: () async {
            await AuthHelper().signOut(context: context);

            return Future.value(true);
          },
          child: Scaffold(
            body: SingleChildScrollView(
              physics: BouncingScrollPhysics(),
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 32.0, vertical: 16),
                    child: Row(
                      children: [
                        // Image(
                        //   image: AssetImage('assets/images/logo.jpeg'),
                        //   width: 60,
                        // ),
                        // // Text("Logo"),
                        // SizedBox(width: 10),
                        Text(
                          'Profile Setup',
                          style: TextStyle(
                            color: kVioletShade,
                            fontSize: 28,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: MediaQuery.of(context).size.height * 0.05),
                  Stack(
                    children: [
                      _image == null
                          ? ClipRRect(
                              borderRadius: BorderRadius.circular(300),
                              child: Image(
                                image: AssetImage('assets/images/profile.png'),
                                alignment: Alignment.center,
                                width: 150,
                                height: 150,
                                fit: BoxFit.cover,
                              ),
                            )
                          : ClipRRect(
                              borderRadius: BorderRadius.circular(300),
                              child: Image.file(
                                _image!,
                                alignment: Alignment.center,
                                width: 150,
                                height: 150,
                                fit: BoxFit.cover,
                              ),
                            ),
                      Positioned(
                        right: 8,
                        bottom: 15,
                        child: InkWell(
                          onTap: () {
                            buildShowModalBottomSheet(context);
                          },
                          child: Icon(
                            FontAwesomeIcons.camera,
                            color: kVioletShade,
                          ),
                        ),
                      ),
                    ],
                  ),
                  Form(
                    key: _formFieldKey,
                    child: Column(
                      children: [
                        SizedBox(height: 60),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              vertical: 8, horizontal: 32),
                          child: Container(
                            padding: EdgeInsets.symmetric(horizontal: 16),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(7),
                              color: Colors.grey.shade100,
                              border: Border.all(
                                  color:
                                      Colors.grey.shade700.withOpacity(0.15)),
                            ),
                            child: DropdownButtonHideUnderline(
                              child: DropdownButton<String>(
                                hint: Row(
                                  children: [
                                    Icon(FontAwesomeIcons.calendar,
                                        color: kVioletShade),
                                    SizedBox(width: 10),
                                    Text("Choose Academic Year"),
                                  ],
                                ),
                                isExpanded: true,
                                items:
                                    academicYears.map(buildMenuYear).toList(),
                                onChanged: (value) {
                                  setState(() {
                                    selectedYear = value;
                                  });
                                },
                                value: selectedYear,
                              ),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              vertical: 8, horizontal: 32),
                          child: Container(
                            padding: EdgeInsets.symmetric(horizontal: 16),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(7),
                              color: Colors.grey.shade100,
                              border: Border.all(
                                  color:
                                      Colors.grey.shade700.withOpacity(0.15)),
                            ),
                            child: DropdownButtonHideUnderline(
                              child: DropdownButton<String>(
                                hint: Row(
                                  children: [
                                    Icon(FontAwesomeIcons.codeBranch,
                                        color: kVioletShade),
                                    SizedBox(width: 10),
                                    Text("Choose Branch"),
                                  ],
                                ),
                                isExpanded: true,
                                items: branches.map(buildMenuBranch).toList(),
                                onChanged: (value) {
                                  setState(() {
                                    selectedBranch = value;
                                  });
                                },
                                value: selectedBranch,
                              ),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 32.0),
                          child: InkWell(
                              onTap: () async {
                                // print(dob);
                                // print(selectedYear);
                                // print(selectedBranch);

                                if (selectedBranch == null ||
                                    selectedBranch == "" ||
                                    selectedYear == null ||
                                    selectedYear == "") {
                                  showErrorMsg();
                                } else {
                                  uploadData();
                                }
                              },
                              child: MyButton(text: 'Done')),
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<dynamic> buildShowModalBottomSheet(BuildContext context) {
    return showModalBottomSheet(
      context: context,
      builder: (builder) {
        return SizedBox(
          height: 200,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Choose an option to upload image',
                style: TextStyle(
                  fontSize: 22,
                  color: kVioletShade,
                ),
              ),
              SizedBox(height: 20),
              Divider(),
              Padding(
                padding: const EdgeInsets.only(left: 32.0),
                child: InkWell(
                  onTap: () {
                    getImage(ImageSource.camera);
                    Navigator.pop(context);
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Icon(
                        Icons.camera,
                        color: kVioletShade,
                      ),
                      SizedBox(width: 10),
                      Text(
                        'Camera',
                        style: TextStyle(
                          fontSize: 18,
                          color: Colors.black,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 10),
              Divider(),
              Padding(
                padding: const EdgeInsets.only(left: 32.0),
                child: InkWell(
                  onTap: () {
                    getImage(ImageSource.gallery);
                    Navigator.pop(context);
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Icon(
                        FontAwesomeIcons.image,
                        color: kVioletShade,
                      ),
                      SizedBox(width: 10),
                      Text(
                        'Gallery',
                        style: TextStyle(
                          fontSize: 18,
                          color: Colors.black,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  // Pick image
  Future getImage(ImageSource imageSource) async {
    try {
      final image =
          await ImagePicker().pickImage(source: imageSource, imageQuality: 50);

      if (image == null) return;

      final imgTemp = File(image.path);

      setState(() {
        _image = imgTemp;
      });
    } on PlatformException catch (e) {
      Fluttertoast.showToast(msg: 'Failed to pick image $e');
    }
  }

  // Upload image
  Future uploadImage() async {
    // print('image $_image');
    if (_image == null) return;

    final imageName = path.basename(_image!.path);
    final destination = 'files/students/$imageName';

    task = FirebaseUpload.uploadFile(destination, _image!);

    if (task == null) return null;

    final snapshot = await task!.whenComplete(() {});
    urlDownload = await snapshot.ref.getDownloadURL().then((value) {
      Provider.of<UserModelProvider>(context, listen: false)
          .updateUserProperty("imageUrl", urlDownload);

      return value;
    });
    // print('urlDownload $urlDownload');
  }
}
