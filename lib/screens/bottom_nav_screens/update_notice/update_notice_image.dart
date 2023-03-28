// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:notice_board/models/notice_model.dart';
import 'package:notice_board/services/notice_services.dart';
import 'package:notice_board/services/pdf_api.dart';
import 'package:notice_board/services/send_notification.dart';
import 'package:notice_board/widgets/auth_button.dart';
import 'package:path/path.dart' as path;
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import '../../../helpers/constants.dart';
import '../../../providers/notice_model_provider.dart';
import '../../../services/firebase_upload.dart';
import '../my_bottom_navigation_bar.dart';
import '../notice_detail/pdf_viewer_screen.dart';

class UpdateNoticeImage extends StatefulWidget {
  const UpdateNoticeImage({Key? key, required this.noticeModel})
      : super(key: key);

  final NoticeModel noticeModel;

  @override
  State<UpdateNoticeImage> createState() => _UpdateNoticeImageState();
}

class _UpdateNoticeImageState extends State<UpdateNoticeImage> {
  String pickedFileName = "";

  // image source
  File? _image;

  // upload task
  UploadTask? task1, task2;

  File? pickedFile;

  String urlDownload = "";

  String urlDownload2 = "";

  bool showSpinner = false;

  @override
  void initState() {
    urlDownload = widget.noticeModel.imageUrl.toString();
    urlDownload2 = widget.noticeModel.pdfUrl.toString();

    pickedFileName = widget.noticeModel.pdfName.toString();

    super.initState();
  }

  void updateNotice(BuildContext context) async {
    NoticeModelProvider noticeModelProvider =
        Provider.of<NoticeModelProvider>(context, listen: false);

    setState(() {
      showSpinner = true;
    });
    await uploadImage();
    await uploadPdf();

    noticeModelProvider.updateNoticeProperty("imageUrl", urlDownload);
    noticeModelProvider.updateNoticeProperty("pdfUrl", urlDownload2);

    await NoticeServices()
        .updateNotice(noticeModelProvider.currentNotice)
        .then((value) {
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
            'Notice ${noticeModelProvider.currentNotice.title.toString()} just get updated. Have a look on it!',
        context: context,
      );
    });
    // print(
    //     "Year ${Provider.of<NoticeModel1Provider>(context, listen: false).year}");

    // await NoticeServices().updateNoticeDetails(
    //   title: Provider.of<NoticeModel1Provider>(context, listen: false).title,
    //   description:
    //       Provider.of<NoticeModel1Provider>(context, listen: false).description,
    //   year: Provider.of<NoticeModel1Provider>(context, listen: false).year,
    //   branch: Provider.of<NoticeModel1Provider>(context, listen: false).branch,
    //   subject:
    //       Provider.of<NoticeModel1Provider>(context, listen: false).subject,
    //   noticeType:
    //       Provider.of<NoticeModel1Provider>(context, listen: false).noticeType,
    //   imageUrl:
    //       Provider.of<NoticeModel1Provider>(context, listen: false).imageUrl,
    //   pdfUrl: Provider.of<NoticeModel1Provider>(context, listen: false).pdfUrl,
    //   pdfName:
    //       Provider.of<NoticeModel1Provider>(context, listen: false).pdfName,
    //   ownerUid:
    //       Provider.of<NoticeModel1Provider>(context, listen: false).ownerUid,
    //   tags: widget.noticeModel.tags,
    //   noticeId: widget.noticeModel.noticeId.toString(),
    // );

    setState(() {
      showSpinner = false;
    });
    // print("OK");
  }

  @override
  Widget build(BuildContext context) {
    // print(Provider.of<NoticeModel1Provider>(context).title);
    // print(
    //     Provider.of<NoticeModel1Provider>(context).description.substring(0, 5));
    // print(Provider.of<NoticeModel1Provider>(context).subject);
    // print(Provider.of<NoticeModel1Provider>(context).year);
    // print(Provider.of<NoticeModel1Provider>(context).branch);
    // print(Provider.of<NoticeModel1Provider>(context).noticeType);
    // print(urlDownload);
    // print(urlDownload2);
    // print("pickedFileName");
    // print(pickedFileName);

    Size size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: kBackGroundColor,
      body: ModalProgressHUD(
        inAsyncCall: showSpinner,
        progressIndicator: CircularProgressIndicator(color: kOrangeColor),
        child: SafeArea(
          child: SizedBox(
            // height: size.height,
            // width: size.width,
            child: SingleChildScrollView(
              physics: BouncingScrollPhysics(),
              child: Column(
                // mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(height: 30),
                  Text(
                    "Update Notice Image",
                    style: TextStyle(
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                      // color: kOrangeShade,
                    ),
                  ),
                  SizedBox(height: 30),
                  _image != null
                      ? Container(
                          decoration: BoxDecoration(
                            border: Border.all(color: kOrangeColor, width: 10),
                          ),
                          child: Image.file(
                            _image!,
                            alignment: Alignment.center,
                            width: size.width * 0.5,
                            height: size.width * 0.7,
                            fit: BoxFit.cover,
                          ),
                        )
                      : urlDownload != ""
                          ? Container(
                              width: size.width * 0.5,
                              height: size.width * 0.7,
                              decoration: BoxDecoration(
                                border:
                                    Border.all(color: kOrangeColor, width: 10),
                              ),
                              child: Image(
                                image: NetworkImage(urlDownload),
                              ),
                            )
                          : Container(
                              width: size.width * 0.5,
                              height: size.width * 0.7,
                              decoration: BoxDecoration(
                                border:
                                    Border.all(color: kOrangeColor, width: 10),
                                image: DecorationImage(
                                  image: AssetImage("assets/images/notice.jpg"),
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                  SizedBox(height: 30),
                  InkWell(
                    onTap: () {
                      buildShowModalBottomSheet(context);
                    },
                    child: Container(
                      padding:
                          EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      decoration: BoxDecoration(
                        border: Border.all(color: kOrangeColor, width: 2),
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: Text(
                        "Choose Image",
                        style: TextStyle(
                            fontSize: 22, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                  SizedBox(height: 30),
                  Center(child: Text("OR")),
                  SizedBox(height: 30),
                  InkWell(
                    onTap: () async {
                      bool result = await _handlePermission(Permission.storage);

                      if (result) {
                        pickedFile = await PDFApi.pickFile();

                        if (pickedFile != null && mounted) {
                          // print("Zingur");
                          // print(path.basename(pickedFile!.path));
                          setState(() {
                            pickedFileName = path.basename(pickedFile!.path);
                          });
                          // Provider.of<NoticeModel1Provider>(context,
                          //         listen: false)
                          //     .updatePdfName(pickedFileName);

                          Provider.of<NoticeModelProvider>(context,
                                  listen: false)
                              .updateNoticeProperty("pdfName", pickedFileName);
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
                    child: Text(
                      "Choose Pdf",
                      style:
                          TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                    ),
                  ),
                  SizedBox(height: 15),
                  if (pickedFile != null || pickedFileName != "")
                    InkWell(
                      onTap: () async {
                        setState(() {
                          showSpinner = true;
                        });
                        String url = widget.noticeModel.pdfUrl.toString();
                        if (pickedFile == null && url != "") {
                          String url = widget.noticeModel.pdfUrl.toString();
                          // print(url);
                          final file =
                              await PDFApi.loadNetwork(url).then((value) {
                            openPDF(context, value,
                                widget.noticeModel.pdfName.toString());
                          });
                        } else if (pickedFile != null) {
                          openPDF(context, pickedFile!, "");
                        }
                        setState(() {
                          showSpinner = false;
                        });
                      },
                      child: Container(
                        padding:
                            EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        decoration: BoxDecoration(
                            border: Border.all(color: Colors.black, width: 1)),
                        child: Text(
                          pickedFileName,
                          style: TextStyle(color: Colors.grey),
                        ),
                      ),
                    ),
                  SizedBox(height: 30),
                  AuthButton(
                    color: kOrangeColor,
                    size: size,
                    name: "Upload",
                    onTap: () async {
                      // print("Hello");
                      // print(urlDownload);
                      // print(urlDownload2);

                      Provider.of<NoticeModelProvider>(context, listen: false)
                          .updateNoticeProperty("imageUrl", urlDownload);

                      Provider.of<NoticeModelProvider>(context, listen: false)
                          .updateNoticeProperty("pdfUrl", urlDownload2);

                      Provider.of<NoticeModelProvider>(context, listen: false)
                          .updateNoticeProperty("pdfName", pickedFileName);

                      // Provider.of<NoticeModel1Provider>(context, listen: false)
                      //     .updateImageUrl(urlDownload);
                      // Provider.of<NoticeModel1Provider>(context, listen: false)
                      //     .updatePdfUrl(urlDownload2);
                      // Provider.of<NoticeModel1Provider>(context, listen: false)
                      // .updatePdfName(pickedFileName);

                      updateNotice(context);
                    },
                  ),
                ],
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

  void openPDF(BuildContext context, File file, String pdfName) =>
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => PDFViewerScreen(
            file: file,
            pdfName: pdfName,
          ),
        ),
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

      // await uploadImage();
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

    if (_image != null && urlDownload != "") {
      FirebaseStorageMethods().deleteFile(urlDownload);
    }

    final snapshot = await task1!.whenComplete(() {});
    urlDownload = await snapshot.ref.getDownloadURL().then((value) {
      Provider.of<NoticeModelProvider>(context, listen: false)
          .updateNoticeProperty("imageUrl", value);

      return value;
    });

    // print('urlDownload $urlDownload');
    // Provider.of<NoticeModel1Provider>(context, listen: false)
    //     .updateImageUrl(urlDownload);

    // print(
    //     "Provider ${Provider.of<NoticeModel1Provider>(context, listen: false).imageUrl}");
  }

  Future uploadPdf() async {
    // print("Uploading PDF");
    if (pickedFile == null) return;
    final path = "files/noticesPdf/$pickedFileName";
    // final file = File(pickedFile!.path);

    final ref = FirebaseStorage.instance.ref().child(path);

    task2 = ref.putFile(pickedFile!);

    if (task2 == null) return null;

    if (pickedFile != null && urlDownload2 != "") {
      FirebaseStorageMethods().deleteFile(urlDownload2);
    }

    final snapshot = await task2!.whenComplete(() {});
    // urlDownload2 = await snapshot.ref.getDownloadURL();

    // print("urlDownload2 $urlDownload2");

    // Provider.of<NoticeModel1Provider>(context, listen: false)
    //     .updatePdfUrl(urlDownload2);

    urlDownload2 = await snapshot.ref.getDownloadURL().then((value) {
      Provider.of<NoticeModelProvider>(context, listen: false)
          .updateNoticeProperty("pdfUrl", value);

      return value;
    });

    // print(
    //     "Provider ${Provider.of<NoticeModel1Provider>(context, listen: false).imageUrl}");
  }
}
