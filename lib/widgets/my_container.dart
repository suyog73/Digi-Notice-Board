// ignore_for_file: prefer_const_constructors

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:notice_board/helpers/constants.dart';
import 'package:notice_board/models/user_model.dart';
import 'package:notice_board/providers/user_model_provider.dart';
import 'package:notice_board/screens/auth_screens/verify_user_screen.dart';
import 'package:provider/provider.dart';

User? user = FirebaseAuth.instance.currentUser!;

class MyContainer2 extends StatelessWidget {
  const MyContainer2({
    Key? key,
    required this.icon,
    required this.text,
    this.onTap,
    this.isEditable = true,
    this.isEmail = false,
  }) : super(key: key);

  final String text;
  final IconData icon;
  final Function? onTap;
  final bool isEditable, isEmail;

  @override
  Widget build(BuildContext context) {
    UserModel userModel = Provider.of<UserModelProvider>(context).currentUser;
    Color mainColor = userModel.isAdmin ? kOrangeColor : kVioletShade;

    Size size = MediaQuery.of(context).size;

    return Container(
      alignment: Alignment.centerLeft,
      width: size.width,
      // height: 55,
      padding: EdgeInsets.symmetric(vertical: 15),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: Colors.grey.shade50,
        border: Border.all(color: Colors.grey.shade700.withOpacity(0.15)),
      ),
      child: Padding(
        padding: const EdgeInsets.only(left: 24.0, right: 12),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Icon(icon, color: mainColor),
                SizedBox(width: 15),
                SizedBox(
                  width: size.width * 0.55,
                  child: Text(
                    text,
                    textAlign: TextAlign.left,
                    style: TextStyle(
                      color: Colors.black.withOpacity(0.8),
                      fontSize: 19,
                    ),
                  ),
                ),
              ],
            ),
            if (isEditable)
              InkWell(
                onTap: () {
                  onTap!();
                },
                child: Icon(
                  Icons.edit,
                  color: mainColor,
                  size: 20,
                ),
              ),
            if (isEmail)
              user!.emailVerified
                  ? InkWell(
                      onTap: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            backgroundColor: mainColor,
                            content: Text(
                              'Email is already verified',
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                        );
                      },
                      child: Icon(
                        Icons.verified_user_rounded,
                        color: mainColor,
                        size: 26,
                      ),
                    )
                  : InkWell(
                      onTap: () {
                        showModalBottomSheet(
                          backgroundColor: Colors.grey.withOpacity(0.3),
                          context: context,
                          builder: (_) {
                            return Container(
                              alignment: Alignment.center,
                              height: MediaQuery.of(context).size.height * 0.1,
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 16.0),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    Text(
                                      'Please verify your email',
                                      style: TextStyle(
                                        fontSize: 20,
                                        color: Colors.white,
                                      ),
                                    ),
                                    InkWell(
                                      onTap: () {
                                        Navigator.of(context).pushReplacement(
                                          MaterialPageRoute(
                                            builder: (context) => VerifyUserScreen(
                                                isAdmin: userModel.isAdmin,
                                              ),
                                          ),
                                        );
                                      },
                                      child: Container(
                                        alignment: Alignment.center,
                                        height: 40,
                                        width: 100,
                                        decoration: BoxDecoration(
                                          color: Colors.red,
                                          borderRadius:
                                              BorderRadius.circular(15),
                                        ),
                                        child: Text(
                                          'Verify',
                                          style: TextStyle(
                                            fontSize: 20,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.white,
                                          ),
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            );
                          },
                        );
                      },
                      child: Icon(
                        Icons.verified_user_rounded,
                        color: Colors.red,
                        size: 26,
                      ),
                    ),
          ],
        ),
      ),
    );
  }
}
