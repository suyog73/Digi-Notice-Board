// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:notice_board/helpers/constants.dart';
import 'package:notice_board/models/user_model.dart';
import 'package:notice_board/screens/bottom_nav_screens/categories/notice_type_screen.dart';
import 'package:notice_board/widgets/my_appbar.dart';
import 'package:provider/provider.dart';

import '../../../providers/user_model_provider.dart';
import 'category_wise_notice.dart';

class CategoryScreen extends StatelessWidget {
  const CategoryScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    UserModel userModel =
        Provider.of<UserModelProvider>(context, listen: false).currentUser;

    return Scaffold(
      appBar: MyAppBar(appBarName: 'Home', isBack: false),
      body: SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            children: [
              CategoryCard(
                title: userModel.year.toString(),
                subTitle: "All notices of your academic year",
                img: 'help',
                imgw: 20,
                imgh: 20,
                color: Color(0xff45E494).withOpacity(0.2),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          CategoryWiseNotice(noticeCategory: "year"),
                    ),
                  );
                },
              ),
              CategoryCard(
                title: userModel.branch.toString(),
                subTitle: "All notices of your branch",
                img: 'subscription',
                imgw: 17.09,
                imgh: 19.87,
                color: Color(0xffE8547C).withOpacity(0.2),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          CategoryWiseNotice(noticeCategory: "branch"),
                    ),
                  );
                },
              ),
              CategoryCard(
                title: "Other Notices",
                subTitle: "List of notices according to notice types.",
                img: 'theme',
                imgw: 18,
                imgh: 18,
                color: Color(0xffECAF1F).withOpacity(0.2),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => NoticeTypeScreen(),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class CategoryCard extends StatelessWidget {
  const CategoryCard({
    Key? key,
    required this.title,
    this.subTitle = '',
    required this.img,
    required this.imgw,
    required this.imgh,
    required this.color,
    this.subtitle2 = '',
    required this.onTap,
  }) : super(key: key);

  final String title, subTitle, subtitle2;
  final String img;
  final double imgw, imgh;
  final Color color;
  final Function onTap;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 18),
      child: InkWell(
        onTap: () {
          onTap();
        },
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 8),
          decoration: BoxDecoration(
            // color: mainColor.withOpacity(0.2),
            borderRadius: BorderRadius.circular(5),
            border: Border.all(color: mainColor(context).withOpacity(0.2)),
          ),
          child: Row(
            children: [
              SettingIcon(img: img, imgw: imgw, imgh: imgh, color: color),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(left: 14),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            title,
                            style: TextStyle(
                              color: Color(0xff000000),
                              fontSize: 20,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          Row(
                            children: [
                              Text(
                                subtitle2,
                                style: TextStyle(
                                  color: Color(0xff60EEFB),
                                  fontSize: 14,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                              SizedBox(width: 13.5),
                              Icon(
                                Icons.keyboard_arrow_right,
                                color: Color(0xff818496),
                              ),
                            ],
                          ),
                        ],
                      ),
                      SizedBox(height: 5),
                      if (subTitle != '')
                        Text(
                          subTitle,
                          style: TextStyle(
                            color: Color(0xff818496),
                            fontSize: 13,
                            fontWeight: FontWeight.w400,
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
    );
  }
}

class SettingIcon extends StatelessWidget {
  const SettingIcon({
    Key? key,
    required this.img,
    required this.imgw,
    required this.imgh,
    required this.color,
  }) : super(key: key);

  final String img;
  final double imgw, imgh;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      height: 46,
      width: 46,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(19),
      ),
      child: Image(
        image: AssetImage('assets/images/$img.png'),
        width: imgw,
        height: imgh,
      ),
    );
  }
}
