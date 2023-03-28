// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:lottie/lottie.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:notice_board/models/notice_model.dart';
import 'package:notice_board/providers/notice_model_provider.dart';
import 'package:notice_board/screens/bottom_nav_screens/notice_detail/pdf_viewer_screen.dart';
import 'package:notice_board/services/notice_services.dart';
import 'package:notice_board/services/pdf_api.dart';
import 'package:notice_board/services/send_notification.dart';
import 'package:notice_board/widgets/auth_button.dart';
import 'package:path/path.dart' as path;
import 'package:permission_handler/permission_handler.dart';
import 'package:notice_board/helpers/constants.dart';
import 'package:notice_board/services/firebase_upload.dart';
import 'package:notice_board/screens/bottom_nav_screens/my_bottom_navigation_bar.dart';
import 'package:provider/provider.dart';

class CreateNoticeImageScreen extends StatefulWidget {
  const CreateNoticeImageScreen({Key? key}) : super(key: key);

  @override
  State<CreateNoticeImageScreen> createState() =>
      _CreateNoticeImageScreenState();
}

class _CreateNoticeImageScreenState extends State<CreateNoticeImageScreen> {
  String pickedFileName = "";

  // image source
  File? _image;

  // upload task
  UploadTask? task1, task2;

  File? pickedFile;

  // Image
  String urlDownload = "";

  // PDF
  String urlDownload2 = "";

  bool showSpinner = false;

  void publishNotice(BuildContext context) async {
    NoticeModelProvider noticeModelProvider =
        Provider.of<NoticeModelProvider>(context, listen: false);

    setState(() {
      showSpinner = true;
    });
    await uploadImage();
    await uploadPdf();

    // setState(() {
    //   NoticeModel.imageUrl = urlDownload;
    //   NoticeModel.pdfUrl = urlDownload2;
    // });

    noticeModelProvider.updateNoticeProperty("imageUrl", urlDownload);
    noticeModelProvider.updateNoticeProperty("pdfUrl", urlDownload2);

    noticeModelProvider.setCurrentNotice(noticeModelProvider.currentNotice);

    if (mounted) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => MyBottomNavigationBar(),
        ),
      );

      SendNotification().localNotifications(
        noticeBranch: noticeModelProvider.currentNotice.branch.toString(),
        noticeYear: noticeModelProvider.currentNotice.year.toString(),
        notificationMsg:
            'New notice is uploaded for ${noticeModelProvider.currentNotice.year.toString()} ${noticeModelProvider.currentNotice.branch.toString()} :- ${noticeModelProvider.currentNotice.title.toString()}',
        context: context,
      );
    }

    // await NoticeServices().uploadNotice(
    //   title: NoticeModel.title.toString(),
    //   description: NoticeModel.description.toString(),
    //   link: NoticeModel.link.toString(),
    //   subject: NoticeModel.subject.toString(),
    //   noticeType: NoticeModel.noticeType.toString(),
    //   imageUrl: NoticeModel.imageUrl.toString(),
    //   pdfUrl: NoticeModel.pdfUrl.toString(),
    //   pdfName: NoticeModel.pdfName.toString(),
    //   year: NoticeModel.year.toString(),
    //   branch: NoticeModel.branch.toString(),
    //   ownerUid: NoticeModel.ownerUid.toString(),
    //   tags: NoticeModel.tags,
    // );

    setState(() {
      showSpinner = false;
    });
    // print("OK");
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: kBackGroundColor,
      appBar: AppBar(
        backgroundColor: mainColor(context),
        title: Text(
          "Upload Notice Image",
          style: TextStyle(
              fontSize: 22, fontWeight: FontWeight.bold, color: Colors.black),
        ),
        iconTheme: IconThemeData(color: Colors.black),
      ),
      body: ModalProgressHUD(
        inAsyncCall: showSpinner,
        progressIndicator: CircularProgressIndicator(color: kOrangeColor),
        child: SafeArea(
          child: SizedBox(
            // height: size.height,
            // width: size.width,
            child: SingleChildScrollView(
              physics: BouncingScrollPhysics(),
              child: Center(
                child: Column(
                  children: [
                    SizedBox(height: size.height * 0.07),
                    _image == null
                        ? Lottie.asset(
                            'assets/lottie/cloud.json',
                            // width: size.width * 0.5,
                            // height: size.height * 0.6,
                          )
                        : Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 38.0),
                            child: Container(
                              decoration: BoxDecoration(
                                border:
                                    Border.all(color: kOrangeColor, width: 1),
                              ),
                              child: Image.file(
                                _image!,
                                alignment: Alignment.center,
                                fit: BoxFit.contain,
                              ),
                            ),
                          ),
                    SizedBox(height: 30),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        InkWell(
                          onTap: () {
                            buildShowModalBottomSheet(context);
                          },
                          child: Column(
                            children: [
                              Container(
                                height: 60,
                                width: 60,
                                decoration: BoxDecoration(
                                  border: Border.all(color: Colors.black),
                                  borderRadius: BorderRadius.circular(30),
                                ),
                                child: Icon(
                                  Icons.image,
                                  color: mainColor(context),
                                  size: 35,
                                ),
                              ),
                              SizedBox(height: 10),
                              Text(
                                "Image",
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(width: size.width * 0.075),
                        Center(child: Text("OR")),
                        SizedBox(width: size.width * 0.075),
                        InkWell(
                          onTap: () async {
                            bool result =
                                await _handlePermission(Permission.storage);
                            if (result) {
                              pickedFile = await PDFApi.pickFile();
                              if (pickedFile != null && mounted) {
                                setState(() {
                                  pickedFileName =
                                      path.basename(pickedFile!.path);
                                  // NoticeModel.pdfName = pickedFileName;
                                });

                                Provider.of<NoticeModelProvider>(context,
                                        listen: false)
                                    .updateNoticeProperty(
                                        "pdfName", pickedFileName);
                              }
                            } else {
                              if (mounted) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    backgroundColor: Colors.redAccent,
                                    content: Text(
                                      'Please provide require permissions to download notice',
                                      style: TextStyle(color: Colors.white),
                                    ),
                                  ),
                                );
                              }
                            }
                          },
                          child: Column(
                            children: [
                              Container(
                                height: 60,
                                width: 60,
                                decoration: BoxDecoration(
                                  border: Border.all(color: Colors.black),
                                  borderRadius: BorderRadius.circular(30),
                                ),
                                child: Icon(
                                  Icons.picture_as_pdf,
                                  color: mainColor(context),
                                  size: 35,
                                ),
                              ),
                              SizedBox(height: 10),
                              Text(
                                "PDF",
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 30),
                    if (pickedFile != null)
                      InkWell(
                        onTap: () async {
                          openPDF(context, pickedFile!);
                        },
                        child: Container(
                          height: size.height * 0.08,
                          width: size.width * 0.5,
                          alignment: Alignment.center,
                          padding:
                              EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: Colors.black,
                              width: 1,
                            ),
                            borderRadius: BorderRadius.circular(15),
                          ),
                          child: SizedBox(
                            width: size.width * 0.5,
                            child: Text(
                              pickedFileName,
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ),
                      ),
                    SizedBox(height: 30),
                    AuthButton(
                      size: size,
                      name: "Publish",
                      onTap: () async {
                        publishNotice(context);
                      },
                      color: kOrangeColor,
                    ),
                    SizedBox(height: 30),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<bool> _handlePermission(Permission permission) async {
    if (await permission.isGranted) {
      return true;
    } else {
      var result = await permission.request();
      if (result == PermissionStatus.granted) {
        return true;
      } else {
        return false;
      }
    }
  }

  void openPDF(BuildContext context, File file) => Navigator.of(context).push(
        MaterialPageRoute(builder: (context) => PDFViewerScreen(file: file)),
      );

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

      await uploadImage();
    } on PlatformException catch (e) {
      Fluttertoast.showToast(msg: 'Failed to pick image $e');
    }
  }

  // Upload image
  Future uploadImage() async {
    // print('image $_image');
    if (_image == null) return;

    final imageName = path.basename(_image!.path);
    final destination = 'files/noticeImage/$imageName';

    task1 = FirebaseUpload.uploadFile(destination, _image!);

    if (task1 == null) return null;

    final snapshot = await task1!.whenComplete(() {});
    urlDownload = await snapshot.ref.getDownloadURL();

    // print('urlDownload $urlDownload');
  }

  // Future selectPdf() async {
  //   final result = await FilePicker.platform.pickFiles(
  //     type: FileType.custom,
  //     allowedExtensions: ["pdf"],
  //   );
  //   if (result == null) return;
  //   setState(() {
  //     pickedFile = result.files.first as File?;
  //   });
  // }

  Future uploadPdf() async {
    if (pickedFile == null) return;

    final path = "files/noticesPdf/$pickedFileName";
    // print("path $path");
    // File file = File(pickedFile.);

    final ref = FirebaseStorage.instance.ref().child(path);

    task2 = ref.putFile(pickedFile!);

    if (task2 == null) return null;

    final snapshot = await task2!.whenComplete(() {});
    urlDownload2 = await snapshot.ref.getDownloadURL();

    // print("urlDownload2 $urlDownload2");
  }
}
