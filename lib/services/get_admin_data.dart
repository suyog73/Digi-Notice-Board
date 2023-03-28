// ignore_for_file: prefer_const_constructors

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:notice_board/helpers/constants.dart';
import 'package:notice_board/providers/user_model_provider.dart';
import 'package:notice_board/screens/bottom_nav_screens/my_bottom_navigation_bar.dart';
import 'package:notice_board/screens/profile_setup/admin_profile_setup.dart';
import 'package:notice_board/services/user_services.dart';
import 'package:provider/provider.dart';
import '../models/user_model.dart';
import '../screens/auth_screens/verify_user_screen.dart';

class GetAdminData extends StatelessWidget {
  const GetAdminData({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    FirebaseAuth auth = FirebaseAuth.instance;
    String uid = auth.currentUser!.uid.toString();

    return Scaffold(
      body: FutureBuilder<UserModel?>(
        future: AdminServices().getAdmin(uid),
        builder: (BuildContext context, AsyncSnapshot<UserModel?> snapshot) {
          if (snapshot.hasError) {
            return Center(
              child: Text('Something went wrong, Please try again'),
            );
          }
          if (snapshot.hasData && snapshot.data == null) {
            print("Not Admin");
            return Center(
              child: CircularProgressIndicator(color: kVioletShade),
            );
          }
          if (snapshot.connectionState == ConnectionState.done) {
            UserModel? userModel = snapshot.data;

            Provider.of<UserModelProvider>(context, listen: false)
                .setCurrentUser(userModel!);

            // UserModel.name = data['Info']['name'].toString();
            // UserModel.isAdmin = data['Info']['isAdmin'];
            // UserModel.email = data['Info']['email'].toString();
            // // UserModel.password = data['Info']['password'].toString();
            // UserModel.imageUrl = data['Info']['imageUrl'].toString();
            // UserModel.branch = data['Info']['branch'].toString();
            // UserModel.uid = data['Info']['uid'].toString();
            // UserModel.adminCategory = data['Info']['category'].toString();
            // UserModel.prn = data['Info']['prn'].toString();
            // UserModel.year = data['Info']['year'].toString();

            UserModel currentUser =
                Provider.of<UserModelProvider>(context, listen: false)
                    .currentUser;

            if (auth.currentUser!.emailVerified) {
              // print("Email verified");
              // print("Admin Category ${UserModel.adminCategory}");
              if (currentUser.adminCategory == null ||
                  currentUser.adminCategory == "") {
                return AdminProfileSetup();
              }
            } else {
              return VerifyUserScreen(isAdmin: true);
            }
            // return HomePage();
            // return AllNotices();
            return MyBottomNavigationBar();
          }
          return Center(
            child: CircularProgressIndicator(color: kOrangeColor),
          );
        },
      ),
    );
  }
}
