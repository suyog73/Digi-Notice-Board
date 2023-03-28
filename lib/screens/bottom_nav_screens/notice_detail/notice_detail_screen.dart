// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'dart:io';
import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dio/dio.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_share/flutter_share.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:notice_board/helpers/constants.dart';
import 'package:notice_board/models/notice_model.dart';
import 'package:notice_board/providers/acknowledgement_provider.dart';
import 'package:notice_board/screens/bottom_nav_screens/notice_detail/ack_screen.dart';
import 'package:notice_board/screens/bottom_nav_screens/notice_detail/pdf_viewer_screen.dart';
import 'package:notice_board/screens/bottom_nav_screens/update_notice/update_notice_screen.dart';
import 'package:notice_board/services/firebase_dynamic_link.dart';
import 'package:notice_board/services/notice_services.dart';
import 'package:notice_board/services/pdf_api.dart';
import 'package:notice_board/widgets/image_viewer.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

import 'package:notice_board/models/user_model.dart';
import 'package:notice_board/widgets/my_bookmark.dart';
import 'package:notice_board/screens/bottom_nav_screens/my_bottom_navigation_bar.dart';
import 'package:notice_board/screens/bottom_nav_screens/user_list/student_profile.dart';

import '../../../providers/user_model_provider.dart';
import '../../../services/timestamp_converter.dart';

class NoticeDetailScreen extends StatefulWidget {
  const NoticeDetailScreen({Key? key, required this.noticeModel})
      : super(key: key);
  final NoticeModel noticeModel;

  @override
  State<NoticeDetailScreen> createState() => _NoticeDetailScreenState();
}

class _NoticeDetailScreenState extends State<NoticeDetailScreen> {
  double progressOfDownload = 0;
  int totalSizeToDownload = 1;
  bool isSpinner = false;

  double priority = -1;
  double prevPriority = -1;

  // final GlobalKey<PopupMenuButtonState<int>> _key = GlobalKey();

  String ownerImageUrl =
      "https://t4.ftcdn.net/jpg/00/65/77/27/360_F_65772719_A1UV5kLi5nCEWI0BNLLiFaBPEkUbv5Fv.jpg";

  CollectionReference userCollection =
      FirebaseFirestore.instance.collection("admins");

  @override
  void didChangeDependencies() async {
    await userCollection
        .doc(widget.noticeModel.ownerUid)
        .get()
        .then((snapshot) {
      // print(snapshot.data());
      Map<String, dynamic> data = snapshot.data() as Map<String, dynamic>;
      if (data["Info"]["imageUrl"] != "") {
        setState(() {
          ownerImageUrl = data['Info']['imageUrl'];
        });
      }
    });

    // NoticeModel.acknowledgeList = widget.noticeModel.acknowledgeList;
    // print("acknowledgeList");
    // print(widget.noticeModel.acknowledgeList);
    super.didChangeDependencies();
  }

  void showDialogBoxToDeleteMessage() {
    showDialog(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(32.0))),
          actionsPadding: EdgeInsets.only(bottom: 10),
          title: Text(
            'Delete Notice',
            style: TextStyle(color: Colors.black, fontSize: 22),
          ),
          actions: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                InkWell(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: Padding(
                    padding:
                        EdgeInsets.symmetric(horizontal: 12.0, vertical: 8),
                    child: Text(
                      'Cancel',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.grey,
                        fontSize: 18,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 15),
                InkWell(
                  onTap: () async {
                    await NoticeServices()
                        .deleteNotice(widget.noticeModel.noticeId.toString())
                        .then((value) {
                      Navigator.of(context).pushAndRemoveUntil(
                          MaterialPageRoute(
                              builder: (context) => MyBottomNavigationBar()),
                          (Route<dynamic> route) => false);
                    });
                  },
                  child: Padding(
                    padding:
                        EdgeInsets.symmetric(horizontal: 12.0, vertical: 8),
                    child: Text(
                      'Delete',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                        color: Colors.red,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        );
      },
    );
  }

  // void showDialogBoxToRate() {
  //   showDialog(
  //     barrierDismissible: false,
  //     context: context,
  //     builder: (context) {
  //       return Center(
  //         child: Container(
  //           padding: EdgeInsets.all(8),
  //           alignment: Alignment.center,
  //           height: MediaQuery.of(context).size.height * 0.3,
  //           width: MediaQuery.of(context).size.width * 0.7,
  //           decoration: BoxDecoration(
  //             color: Colors.white,
  //             borderRadius: BorderRadius.circular(5),
  //             border: Border.all(),
  //             boxShadow: [
  //               BoxShadow(
  //                 color: Colors.white.withOpacity(0.5),
  //                 spreadRadius: 5,
  //                 blurRadius: 7,
  //                 offset: Offset(0, 3), // changes position of shadow
  //               ),
  //             ],
  //           ),
  //           child: Padding(
  //             padding: const EdgeInsets.symmetric(vertical: 18.0),
  //             child: Column(
  //               crossAxisAlignment: CrossAxisAlignment.center,
  //               children: [
  //                 Text(
  //                   "Set the priority for this notice",
  //                   textAlign: TextAlign.center,
  //                   style: TextStyle(
  //                     fontSize: 18,
  //                     fontWeight: FontWeight.w500,
  //                     color: Colors.black,
  //                     decoration: TextDecoration.none,
  //                   ),
  //                 ),
  //                 SizedBox(height: MediaQuery.of(context).size.height * 0.03),
  //                 RatingBar.builder(
  //                   initialRating: priority,
  //                   minRating: 1,
  //                   direction: Axis.horizontal,
  //                   allowHalfRating: false,
  //                   itemCount: 5,
  //                   itemPadding: EdgeInsets.symmetric(horizontal: 4.0),
  //                   itemBuilder: (context, _) => Icon(
  //                     Icons.star,
  //                     color: Colors.amber,
  //                   ),
  //                   onRatingUpdate: (rating) {
  //                     setState(() {
  //                       prevPriority = priority;
  //                       priority = rating;
  //                     });
  //                   },
  //                 ),
  //                 SizedBox(height: MediaQuery.of(context).size.height * 0.05),
  //                 GestureDetector(
  //                   onTap: () async {
  //                     await PriorityHelper().deletePriority(
  //                       noticeId: widget.noticeModel.noticeId,
  //                       priority: prevPriority,
  //                     );

  //                     await PriorityHelper().addPriority(
  //                       noticeId: widget.noticeModel.noticeId,
  //                       priority: priority,
  //                     );

  //                     Navigator.pop(context);
  //                     print(priority);
  //                   },
  //                   child: Container(
  //                     alignment: Alignment.center,
  //                     height: MediaQuery.of(context).size.height * 0.05,
  //                     width: MediaQuery.of(context).size.width * 0.5,
  //                     decoration: BoxDecoration(
  //                       color: mainColor(context),
  //                       borderRadius: BorderRadius.circular(5),
  //                     ),
  //                     child: Text(
  //                       "Done",
  //                       textAlign: TextAlign.center,
  //                       style: TextStyle(
  //                         fontSize: 22,
  //                         fontWeight: FontWeight.w600,
  //                         color: textColor(context),
  //                         decoration: TextDecoration.none,
  //                       ),
  //                     ),
  //                   ),
  //                 ),
  //               ],
  //             ),
  //           ),
  //         ),
  //       );
  //     },
  //   );
  // }

  Future<void> _launch(String url) async {
    print("url");
    print(url);
    Uri uri = Uri.https(url);

    try {
      await launchUrl(uri);
    } catch (e) {
      print(e);
      throw 'Could not launch $url';
    }
  }

  @override
  Widget build(BuildContext context) {
    UserModel userModel =
        Provider.of<UserModelProvider>(context, listen: false).currentUser;

    AcknowledgementProvider acknowledgementProvider =
        Provider.of<AcknowledgementProvider>(context, listen: false);

    bool isAdmin = userModel.isAdmin;

    String ownerName = widget.noticeModel.ownerUid.toString()[0].toUpperCase() +
        widget.noticeModel.ownerUid.toString().substring(1);

    int ownerNameLength = widget.noticeModel.ownerUid.toString().length;

    String noticeTitle = widget.noticeModel.title.toString();
    noticeTitle = noticeTitle[0].toUpperCase() + noticeTitle.substring(1);

    List<dynamic> acknowledgeList = widget.noticeModel.acknowledgeList;
    // String createdTime = TimestampConverter()
    //     .getTimeFromTimestamp(widget.noticeModel.timeStamp!);
    String createdDate = TimestampConverter()
        .getDateFromTimestamp(widget.noticeModel.timeStamp!);

    // print("_acknowledgeList");
    // print(_acknowledgeList);

    Size size = MediaQuery.of(context).size;

    return WillPopScope(
      onWillPop: () {
        Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => MyBottomNavigationBar()),
            (route) => false);
        return Future.value(true);
      },
      child: Scaffold(
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(70),
          child: AppBar(
            backgroundColor: mainColor(context),
            automaticallyImplyLeading: true,
            iconTheme: IconThemeData(color: Colors.black),
            flexibleSpace: Padding(
              padding: const EdgeInsets.only(bottom: 4),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => StudentProfile(
                            userUid: widget.noticeModel.ownerUid.toString(),
                            isCurrentUserAdmin: true,
                          ),
                        ),
                      );
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            SizedBox(width: 50),
                            Container(
                              width: 55,
                              height: 55,
                              decoration: BoxDecoration(
                                border: Border.all(
                                    color: mainColor(context), width: 2),
                                borderRadius: BorderRadius.circular(300),
                              ),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(300),
                                child: ImageViewer(
                                  width: 50,
                                  height: 50,
                                  isAdmin: true,
                                  finalWidth: size.width,
                                  urlDownload: ownerImageUrl,
                                  finalHeight: size.height,
                                ),
                              ),
                            ),
                            SizedBox(width: 10),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  ownerNameLength > 13
                                      ? "${ownerName.substring(0, 13)} ..."
                                      : ownerName,
                                  style: TextStyle(
                                    fontSize: 22,
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                SizedBox(height: 3),
                                Text(
                                  createdDate.toString(),
                                  style: TextStyle(
                                    color: Colors.black,
                                  ),
                                )
                              ],
                            ),
                          ],
                        ),
                        Padding(
                          padding: const EdgeInsets.all(18.0),
                          child: Row(
                            children: [
                              if (!isAdmin) ...[
                                // InkWell(
                                //   onTap: () {
                                //     showDialogBoxToRate();
                                //   },
                                //   child: Icon(
                                //     Icons.star,
                                //     size: 28,
                                //     color: Colors.tealAccent,
                                //   ),
                                // ),
                                InkWell(
                                  onTap: () async {
                                    await DynamicLinkService()
                                        .createDynamicLink(widget
                                            .noticeModel.noticeId
                                            .toString())
                                        .then((value) {
                                      print("value");
                                      print(value);
                                      FlutterShare.share(
                                        title: value,
                                        linkUrl: value,
                                      );
                                    });
                                  },
                                  child: Icon(
                                    Icons.share,
                                    size: 28,
                                    color: Colors.white,
                                  ),
                                ),

                                SizedBox(width: 15),
                                MyBookmark(noticeModel: widget.noticeModel)
                              ],
                              if (isAdmin &&
                                  widget.noticeModel.ownerUid ==
                                      userModel.uid) ...[
                                InkWell(
                                    onTap: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              UpdateNoticeScreen(
                                                  noticeModel:
                                                      widget.noticeModel),
                                        ),
                                      );
                                    },
                                    child: Icon(Icons.edit, size: 30)),
                                SizedBox(width: 20),
                                InkWell(
                                    onTap: () {
                                      showDialogBoxToDeleteMessage();
                                    },
                                    child: Icon(Icons.delete,
                                        size: 30, color: Colors.pink)),
                              ],
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        body: ModalProgressHUD(
          inAsyncCall: isSpinner,
          progressIndicator:
              CircularProgressIndicator(color: mainColor(context)),
          child: SafeArea(
            child: Container(
              height: size.height,
              width: size.width,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(5),
                // border: Border.all(color: Colors.grey),
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 18.0),
                child: SingleChildScrollView(
                  // physics: BouncingScrollPhysics(),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: 10),
                      Container(
                        decoration: BoxDecoration(),
                        child: Column(
                          children: [
                            if (widget.noticeModel.imageUrl.toString() != "")
                              ImageViewer1(
                                urlDownload:
                                    widget.noticeModel.imageUrl.toString(),
                                finalWidth: size.width,
                                finalHeight: size.height,
                                height: size.width,
                                width: size.width,
                                isAdmin: true,
                              ),
                          ],
                        ),
                      ),
                      if (widget.noticeModel.imageUrl.toString() != "") ...[
                        Divider(color: Colors.black),
                        SizedBox(height: 5)
                      ],
                      Card(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                          side: BorderSide(
                            color: Colors.grey.withOpacity(0.4),
                            width: 1,
                          ),
                        ),
                        child: Padding(
                          padding: EdgeInsets.symmetric(
                              vertical: 15, horizontal: 15),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Icon(FontAwesomeIcons.diceD6),
                                  SizedBox(width: 10),
                                  SizedBox(
                                    width: size.width * 0.3,
                                    child: Text(
                                      noticeTitle,
                                      style: TextStyle(
                                        fontSize: 22,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(
                                width: size.width * 0.4,
                                child: Align(
                                  alignment: Alignment.centerRight,
                                  child: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Icon(Icons.subject),
                                      SizedBox(width: 3),
                                      SizedBox(
                                        // height: 30,
                                        width: size.width * 0.3,
                                        child: Text(
                                          widget.noticeModel.subject.toString(),
                                          // textAlign: TextAlign.right,
                                          style: TextStyle(
                                            fontSize: 20,
                                            fontWeight: FontWeight.w400,
                                            color: kVioletShade,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(height: 15),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 18.0, vertical: 8),
                        child: Text(
                          widget.noticeModel.description.toString(),
                          style: TextStyle(fontSize: 18),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 18.0, vertical: 8),
                        child: RichText(
                          text: TextSpan(
                            children: [
                              TextSpan(
                                text: 'External Link:- ',
                                style: TextStyle(
                                    fontSize: 18, color: Colors.black),
                              ),
                              TextSpan(
                                text: widget.noticeModel.link.toString(),
                                style: TextStyle(
                                  color: Colors.blue,
                                  fontSize: 18,
                                  decoration: TextDecoration.underline,
                                ),
                                recognizer: TapGestureRecognizer()
                                  ..onTap = () async {
                                    await _launch(
                                      widget.noticeModel.link.toString(),
                                    );
                                  },
                              ),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(height: 25),
                      if (widget.noticeModel.imageUrl.toString() != "" ||
                          widget.noticeModel.pdfUrl.toString() != "") ...[
                        Text(
                          "Attachments",
                          style: TextStyle(
                              fontSize: 26, color: mainColor(context)),
                        ),
                        SizedBox(height: 10)
                      ],
                      if (widget.noticeModel.imageUrl.toString() != "") ...[
                        InkWell(
                          onTap: () async {
                            bool result =
                                await _handlePermission(Permission.storage);
                            if (result) {
                              await _save(
                                  noticeUrl:
                                      widget.noticeModel.imageUrl.toString());
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
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  Image(
                                    image:
                                        AssetImage("assets/images/gallery.png"),
                                    height: 30,
                                  ),
                                  SizedBox(width: 10),
                                  Text(
                                    "Download Notice",
                                    style: TextStyle(
                                        color: Colors.black, fontSize: 18),
                                  )
                                ],
                              ),
                              Padding(
                                padding: const EdgeInsets.only(right: 8.0),
                                child: SizedBox(
                                  width: 50,
                                  height: 50,
                                  child: progressOfDownload == 0
                                      ? Icon(Icons.download)
                                      : Stack(
                                          fit: StackFit.expand,
                                          children: [
                                            CircularProgressIndicator(
                                              value: progressOfDownload,
                                              strokeWidth: 4,
                                              backgroundColor: Colors.black,
                                              // color: mainColor,
                                              valueColor:
                                                  AlwaysStoppedAnimation(
                                                      mainColor(context)),
                                            ),
                                            Center(
                                              child: buildProgress(),
                                            ),
                                          ],
                                        ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: 15)
                      ],
                      if (widget.noticeModel.pdfUrl.toString() != "") ...[
                        InkWell(
                          onTap: () async {
                            setState(() {
                              isSpinner = true;
                            });
                            String url = widget.noticeModel.pdfUrl.toString();
                            // final file =
                            await PDFApi.loadNetwork(url).then((value) {
                              // print(value);
                              openPDF(context, value,
                                  widget.noticeModel.pdfName.toString());
                            });
                            // print(file);

                            setState(() {
                              isSpinner = false;
                            });
                          },
                          child: Row(
                            children: [
                              Image(
                                image: AssetImage("assets/images/pdf.png"),
                                height: 30,
                              ),
                              SizedBox(width: 10),
                              Flexible(
                                child: Text(
                                  widget.noticeModel.pdfName.toString(),
                                  style: TextStyle(
                                      color: Colors.black, fontSize: 18),
                                ),
                              )
                            ],
                          ),
                        ),
                        SizedBox(height: 15)
                      ],
                      buildInputChip(widget.noticeModel),
                      SizedBox(height: 30),
                      if (!isAdmin)
                        InkWell(
                          onTap: () async {
                            getToast(acknowledgeList, userModel.uid.toString());

                            acknowledgementProvider.addAcknowledgement();
                            // Provider.of<AcknowledgementProvider>(context,
                            //         listen: false)
                            //     .addAcknowledge(UserModel.uid);

                            // await AcknowledgeHelper().addAcknowledgeUserId(
                            //     noticeId: widget.noticeModel.noticeId);
                          },
                          child: Container(
                            alignment: Alignment.center,
                            padding: EdgeInsets.symmetric(horizontal: 18),
                            height: 50,
                            width: size.width,
                            decoration: BoxDecoration(
                              border: Border.all(color: kVioletShade),
                              borderRadius: BorderRadius.circular(5),
                              // color: kVioletShade,
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  getText(acknowledgeList,
                                      userModel.uid.toString()),
                                  style: TextStyle(
                                    fontSize: 20,
                                    color: getColor(acknowledgeList,
                                        userModel.uid.toString()),
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                Icon(
                                  getIcon(acknowledgeList,
                                      userModel.uid.toString()),
                                  color: getColor(acknowledgeList,
                                      userModel.uid.toString()),
                                  size: 30,
                                )
                              ],
                            ),
                          ),
                        ),
                      if (isAdmin &&
                          (widget.noticeModel.ownerUid == userModel.uid)) ...[
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            InkWell(
                              onTap: () async {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => AckScreen(
                                      title: "Seen",
                                      isSeen: true,
                                      noticeModel: widget.noticeModel,
                                    ),
                                  ),
                                );
                              },
                              child: AckButton(title: 'Seen'),
                            ),
                            InkWell(
                              onTap: () async {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => AckScreen(
                                      title: "Acknowledge",
                                      noticeModel: widget.noticeModel,
                                      isSeen: false,
                                    ),
                                  ),
                                );
                              },
                              child: AckButton(
                                title: "Acknowledge",
                              ),
                            ),
                          ],
                        ),
                      ],
                      SizedBox(height: 30),
                    ],
                  ),
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

  _save({required String noticeUrl}) async {
    var response = await Dio()
        .get(noticeUrl, options: Options(responseType: ResponseType.bytes),
            onReceiveProgress: (int received, int total) {
      // print("$received $total");
      setState(() {
        progressOfDownload = received / total;
        totalSizeToDownload = total;
      });
    });
    final result = await ImageGallerySaver.saveImage(
      Uint8List.fromList(response.data),
      quality: 60,
      name: "NoticeApp",
    );

    // print(result['isSuccess']);
    if (result['isSuccess'] && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: mainColor(context),
          content: Text(
            'Image saved to gallery successfully',
            style: TextStyle(color: Colors.white),
          ),
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: Colors.redAccent,
          content: Text(
            "Unable to download notice",
            style: TextStyle(color: Colors.white),
          ),
        ),
      );
    }
  }

  void openPDF(BuildContext context, File file, String pdfName) =>
      Navigator.of(context).push(
        MaterialPageRoute(
            builder: (context) =>
                PDFViewerScreen(file: file, pdfName: pdfName)),
      );

  Widget buildInputChip(NoticeModel noticeModel) => Wrap(
        runSpacing: 0,
        spacing: 8,
        children: noticeModel.tags.map(
          (inputChip) {
            return InputChip(
              backgroundColor: Colors.grey.withOpacity(0.2),
              label: Text(inputChip),
              labelStyle: const TextStyle(
                  fontWeight: FontWeight.bold, color: Colors.black),
              onPressed: () {},
            );
          },
        ).toList(),
      );

  Widget buildProgress() {
    if (progressOfDownload == 1) {
      return Icon(Icons.file_download_done_sharp, color: Colors.black);
    } else {
      return Text("${(progressOfDownload * 100).toStringAsFixed(1)}%");
    }
  }

  void getToast(List<dynamic> acknowledgeList, String uid) {
    if (acknowledgeList.contains(uid)) {
      Fluttertoast.showToast(msg: "Notice is already acknowledged");
    } else {
      Fluttertoast.showToast(msg: "Acknowledge successfully");
    }
  }
}

IconData getIcon(List<dynamic> acknowledgeList, String uid) {
  if (acknowledgeList.contains(uid)) {
    return Icons.verified;
  } else {
    return Icons.error;
  }
}

String getText(List<dynamic> acknowledgeList, String uid) {
  if (acknowledgeList.contains(uid)) {
    return "Already Acknowledge";
  } else {
    return "Acknowledge Notice";
  }
}

Color getColor(List<dynamic> acknowledgeList, String uid) {
  if (acknowledgeList.contains(uid)) {
    return kGreenShadeColor;
  } else {
    return Colors.redAccent;
  }
}

class AckButton extends StatelessWidget {
  const AckButton({
    Key? key,
    required this.title,
  }) : super(key: key);

  final String title;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Container(
      alignment: Alignment.center,
      height: 50,
      width: size.width * 0.43,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        color: mainColor(context),
      ),
      child: Text(
        title,
        style: TextStyle(
          fontSize: 20,
          color: Colors.black,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}
