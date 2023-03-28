// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:notice_board/helpers/constants.dart';
import 'package:notice_board/models/user_model.dart';
import 'package:notice_board/screens/bottom_nav_screens/categories/category_screen.dart';
import 'package:notice_board/screens/bottom_nav_screens/setting/developer_info.dart';
import 'package:notice_board/screens/bottom_nav_screens/setting/user_manual.dart';
import 'package:notice_board/screens/bottom_nav_screens/setting/my_profile.dart';
import 'package:provider/provider.dart';

import '../../../providers/user_model_provider.dart';
import '../../../widgets/image_viewer.dart';
import '../../../widgets/my_appbar.dart';

class SettingScreen extends StatefulWidget {
  const SettingScreen({Key? key}) : super(key: key);

  @override
  State<SettingScreen> createState() => _SettingScreenState();
}

class _SettingScreenState extends State<SettingScreen> {
  // final bool _isAdmin = UserModel.isAdmin;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    UserModelProvider userModelProvider =
        Provider.of<UserModelProvider>(context, listen: false);

    bool isAdmin = userModelProvider.currentUser.isAdmin;
    String uid = userModelProvider.currentUser.uid.toString();
    String imageUrl = userModelProvider.currentUser.imageUrl.toString();
    Size size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: MyAppBar(
        appBarName: 'Setting',
        isBack: false,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            children: [
              SizedBox(height: 20),
              Expanded(
                child: SingleChildScrollView(
                  physics: BouncingScrollPhysics(),
                  child: Column(
                    children: [
                      InkWell(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => MyProfileScreen(),
                            ),
                          );
                        },
                        child: SizedBox(
                          width: size.width,
                          child: Row(
                            children: [
                              Row(
                                children: [
                                  Hero(
                                    tag: kHeroTag1,
                                    child: ImageViewer2(
                                      height: 80,
                                      width: 80,
                                      imageUrl: userModelProvider
                                          .currentUser.imageUrl
                                          .toString(),
                                    ),
                                  ),
                                  SizedBox(width: 10),
                                  Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      SizedBox(
                                        width:
                                            MediaQuery.of(context).size.width *
                                                0.54,
                                        child: Text(
                                          userModelProvider.currentUser.name
                                              .toString(),
                                          style: TextStyle(
                                            color: mainColor(context),
                                            fontSize: 22,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                      ),
                                      SizedBox(height: 5),
                                      SizedBox(
                                        width:
                                            MediaQuery.of(context).size.width *
                                                0.54,
                                        child: Text(
                                          isAdmin
                                              ? userModelProvider
                                                  .currentUser.adminCategory
                                                  .toString()
                                              : "${userModelProvider
                                                      .currentUser.year} - ${userModelProvider
                                                      .currentUser.branch}",
                                          style: TextStyle(
                                            color: Colors.grey.shade500,
                                            fontSize: 16,
                                          ),
                                        ),
                                      ),
                                    ],
                                  )
                                ],
                              ),
                              Icon(Icons.edit),
                            ],
                          ),
                        ),
                      ),
                      Divider(),
                      SizedBox(height: 35),
                      CategoryCard(
                        title: "Developer Information",
                        subTitle: "Information about guide and developers",
                        img: 'wallet',
                        imgw: 17.09,
                        imgh: 19.87,
                        color: Color(0xff60EEFB).withOpacity(0.2),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => DeveloperInfo(),
                            ),
                          );
                        },
                      ),
                      CategoryCard(
                        title: "User manual",
                        subTitle: "Guide about how to use WCE-NOTICE app",
                        img: 'route',
                        imgw: 17.09,
                        imgh: 19.87,
                        color: Color(0xffECAF1F).withOpacity(0.2),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => UserManual(),
                            ),
                          );
                        },
                      ),
                      // CategoryCard(
                      //   title: "About app",
                      //   subTitle: "Everything about WCE-NOTICE app",
                      //   img: 'terms',
                      //   imgw: 17.09,
                      //   imgh: 19.87,
                      //   color: Color(0xffE8547C).withOpacity(0.2),
                      //   onTap: () {
                      //     Navigator.push(
                      //       context,
                      //       MaterialPageRoute(
                      //         builder: (context) => DeveloperInfo(),
                      //       ),
                      //     );
                      //   },
                      // ),
                      SizedBox(height: 30),
                      Text(
                        "Version $appVersion",
                        style: TextStyle(
                            fontWeight: FontWeight.w600, fontSize: 16),
                      ),
                      Text(
                        "Beta",
                        style: TextStyle(color: kLightBlueShadeColor),
                      ),
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

class MyContainer5 extends StatelessWidget {
  const MyContainer5({
    Key? key,
    required this.text,
    required this.icon,
    required this.onTap,
    required this.color1,
    required this.color2,
    this.subText = '',
  }) : super(key: key);

  final String text, subText;
  final IconData icon;
  final Function onTap;
  final Color color1, color2;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    Color textColor = kBlueShadeColor;

    return InkWell(
      onTap: () {
        onTap();
      },
      child: Container(
        alignment: Alignment.centerLeft,
        width: size.width,
        height: 65,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: Colors.grey.shade50,
          border: Border.all(color: Colors.grey.shade700.withOpacity(0.15)),
        ),
        child: Padding(
          padding: const EdgeInsets.only(left: 15.0, right: 15),
          child: Row(
            children: [
              MyBox(
                color1: color1,
                color2: color2,
                icon: icon,
              ),
              SizedBox(width: 15),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    text,
                    style: TextStyle(color: textColor, fontSize: 19),
                  ),
                  SizedBox(height: 5),
                  Text(
                    subText,
                    style: TextStyle(color: Colors.grey, fontSize: 14),
                  )
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class MyBox extends StatelessWidget {
  const MyBox({
    Key? key,
    required this.color1,
    required this.icon,
    required this.color2,
    this.iconSize = 28,
  }) : super(key: key);
  final Color color1, color2;
  final IconData icon;
  final double iconSize;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 46,
      width: 46,
      decoration: BoxDecoration(
        color: color1,
        borderRadius: BorderRadius.circular(19),
      ),
      child: Icon(
        icon,
        color: color2,
        size: iconSize,
      ),
    );
  }
}
