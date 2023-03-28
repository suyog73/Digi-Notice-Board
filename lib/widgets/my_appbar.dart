// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:notice_board/helpers/constants.dart';
import 'package:notice_board/models/user_model.dart';
import 'package:provider/provider.dart';

import '../providers/user_model_provider.dart';

class MyAppBar extends StatelessWidget with PreferredSizeWidget {
  const MyAppBar({
    Key? key,
    required this.appBarName,
    this.isChangeColor = false,
    this.color = kOrangeColor,
    this.isBack = true,
  }) : super(key: key);

  final String appBarName;
  final bool isChangeColor, isBack;
  final Color color;

  @override
  Widget build(BuildContext context) {
    
  UserModel userModel =
      Provider.of<UserModelProvider>(context, listen: false).currentUser;
      
    return AppBar(
      backgroundColor: isChangeColor ? color : mainColor(context),
      automaticallyImplyLeading: isBack,
      iconTheme:
          IconThemeData(color: userModel.isAdmin ? Colors.black : Colors.white),
      title: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Text(
          appBarName,
          style: TextStyle(
            color: userModel.isAdmin ? Colors.black : Colors.white,
            fontSize: 22,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);
}
