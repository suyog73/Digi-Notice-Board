// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors

import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:notice_board/helpers/constants.dart';
import 'package:notice_board/models/user_model.dart';
import 'package:notice_board/screens/bottom_nav_screens/all_notices.dart';
import 'package:notice_board/screens/bottom_nav_screens/bookmark_notices.dart';
import 'package:notice_board/screens/bottom_nav_screens/categories/category_screen.dart';
import 'package:notice_board/screens/bottom_nav_screens/my_notices.dart';
import 'package:notice_board/screens/bottom_nav_screens/setting/setting_screen.dart';
import 'package:notice_board/screens/bottom_nav_screens/todo/todo_list.dart';
import 'package:provider/provider.dart';
import '../../providers/user_model_provider.dart';
import '../../services/auth_helper.dart';
import 'create_notice/create_notice_main.dart';

class MyBottomNavigationBar extends StatefulWidget {
  const MyBottomNavigationBar({Key? key, this.idx = 2}) : super(key: key);

  final int idx;
  @override
  State<MyBottomNavigationBar> createState() => _MyBottomNavigationBarState();
}

class _MyBottomNavigationBarState extends State<MyBottomNavigationBar> {
  final GlobalKey<CurvedNavigationBarState> _bottomNavigationKey = GlobalKey();

  int _index = 2;

  void onItemTap(int index) {
    setState(() {
      _index = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    UserModel userModel =
        Provider.of<UserModelProvider>(context, listen: false).currentUser;

    FirebaseMessaging.instance.getToken().then((value) {
      AuthHelper().storeToken(token: value, isAdmin: userModel.isAdmin);
    });

    List<Widget> screens = [
      // UserProfileScreen(),
      userModel.isAdmin ? MyNotices() : CategoryScreen(),
      TodoList(),
      AllNotices(),
      userModel.isAdmin ? CreateNoticeMain() : BookmarkNotices(),
      SettingScreen(),
    ];

    Color unSelectedIconColor = kBlueShadeColor.withOpacity(0.7);
    Color selectedIconColor = mainColor(context);
    Color backgroundColor = Colors.white;
    Color color = Colors.grey.shade200;

    return Scaffold(
      resizeToAvoidBottomInset: false,
      extendBody: true,
      backgroundColor: backgroundColor,
      bottomNavigationBar: CurvedNavigationBar(
        color: color,
        buttonBackgroundColor: Colors.transparent,
        backgroundColor: Colors.transparent,
        key: _bottomNavigationKey,
        index: _index,
        height: 65,
        items: [
          Icon(
            userModel.isAdmin ? Icons.assignment : Icons.dashboard,
            color: _index == 0 ? selectedIconColor : unSelectedIconColor,
            size: 32,
          ),
          Icon(
            Icons.check_box_outlined,
            color: _index == 1 ? selectedIconColor : unSelectedIconColor,
            size: 32,
          ),
          Icon(
            Icons.home,
            color: _index == 2 ? selectedIconColor : unSelectedIconColor,
            size: 32,
          ),
          Icon(
            userModel.isAdmin ? Icons.border_color : Icons.bookmark,
            color: _index == 3 ? selectedIconColor : unSelectedIconColor,
            size: 32,
          ),
          Icon(
            Icons.settings,
            color: _index == 4 ? selectedIconColor : unSelectedIconColor,
            size: 32,
          ),
        ],
        onTap: (index) => setState(() {
          onItemTap(index);
        }),
      ),
      body: Container(
        height: MediaQuery.of(context).size.height,
        color: Colors.black,
        child: screens[_index],
      ),
    );
  }
}
