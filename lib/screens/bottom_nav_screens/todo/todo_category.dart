// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:notice_board/helpers/constants.dart';
import 'package:notice_board/screens/bottom_nav_screens/categories/category_screen.dart';
import 'package:notice_board/screens/bottom_nav_screens/todo/priority_wise_notices.dart';
import 'package:notice_board/screens/bottom_nav_screens/todo/todo_list.dart';

class TodoCategory extends StatelessWidget {
  const TodoCategory({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("My Todo Categories"),
        backgroundColor: mainColor(context),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0),
        child: Column(
          children: [
            TodoCategoryCard(
              title: "Personal Todo",
              subTitle: "All of your personal tasks",
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => TodoList(),
                  ),
                );
              },
            ),
            TodoCategoryCard(
              title: " Priority",
              priority: 5,
              // subTitle: "",
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => TodoList(),
                  ),
                );
              },
            ),
            TodoCategoryCard(
              title: " Priority",
              priority: 4, // subTitle: "All of your personal tasks",
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => TodoList(),
                  ),
                );
              },
            ),
            TodoCategoryCard(
              title: " Priority",
              priority: 3,
              // subTitle: "All of your personal tasks",
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => TodoList(),
                  ),
                );
              },
            ),
            TodoCategoryCard(
              title: " Priority",
              priority: 2,
              // subTitle: "All of your personal tasks",
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => TodoList(),
                  ),
                );
              },
            ),
            TodoCategoryCard(
              title: " Priority",
              priority: 1,
              // subTitle: "All of your personal tasks",
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => PriorityWiseNotices(priority: 1),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

class TodoCategoryCard extends StatelessWidget {
  const TodoCategoryCard({
    Key? key,
    required this.title,
    this.subTitle = '',
    this.subtitle2 = '',
    required this.onTap,
    this.iconData,
    this.priority = 0,
  }) : super(key: key);

  final String title, subTitle, subtitle2;
  final IconData? iconData;
  final int priority;
  final Function onTap;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 18),
      child: InkWell(
        onTap: () {
          onTap();
        },
        child: Card(
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 8),
            decoration: BoxDecoration(
              color: Colors.white,
              // color: mainColor(context).withOpacity(0.2),
              borderRadius: BorderRadius.circular(5),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.5),
                  spreadRadius: 3,
                  blurRadius: 7,
                  offset: Offset(0, 2), // changes position of shadow
                ),
              ],
            ),
            child: Row(
              children: [
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
                            Row(
                              children: [
                                if (priority > 0) ...[
                                  Text(
                                    priority.toString(),
                                    style: TextStyle(
                                      color: Color(0xff000000),
                                      fontSize: 20,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  Icon(
                                    Icons.star,
                                    color: Colors.amber,
                                  )
                                ],
                                Text(
                                  title,
                                  style: TextStyle(
                                    color: Color(0xff000000),
                                    fontSize: 20,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
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
      ),
    );
  }
}
