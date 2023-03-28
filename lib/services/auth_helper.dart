// ignore_for_file: prefer_const_constructors

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:notice_board/helpers/constants.dart';
import 'package:notice_board/models/teachers_model.dart';
import 'package:notice_board/screens/auth_screens/student_login_screen.dart';

import '../screens/auth_screens/admin_login_screen.dart';

class AuthHelper {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  get user => _auth.currentUser;

  // SignUp Method
  Future signUp(
      {required String email,
      required String password,
      bool isAdmin = false}) async {
    if (isAdmin) {
      bool isValid = TeachersModel.teachersEmail.contains(email);
      print("isValid $isValid");
      if (!isValid) {
        return "You don't have the admin access.";
      }
    }

    try {
      await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      print('Register successfully');

      return null;
    } on FirebaseAuthException catch (e) {
      return e.message;
    }
  }

  //SignIn method
  Future signIn({
    required String email,
    required String password,
    bool isAdmin = false,
  }) async {
    if (isAdmin) {
      bool isValid = TeachersModel.teachersEmail.contains(email);
      debugPrint("isValid $isValid");
      if (!isValid) {
        return "You don't have the admin access.";
      }
    }

    try {
      await _auth.signInWithEmailAndPassword(email: email, password: password);
      print('Login successfully');

      return null;
    } on FirebaseAuthException catch (e) {
      return e.message;
    }
  }

  //SignOut Method
  Future signOut({required BuildContext context, bool isAdmin = false}) async {
    await _auth.signOut().then((value) {
      print('signout');
      Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(
            builder: (context) =>
                isAdmin ? AdminLoginScreen() : StudentLoginScreen(),
          ),
          (Route<dynamic> route) => false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: isAdmin ? kOrangeColor : kVioletShade,
          content: Text(
            'Logout Successfully',
            style: TextStyle(color: Colors.white),
          ),
        ),
      );
    });
  }

  Future verifyEmail({required context, required bool isAdmin}) async {
    try {
      final user = FirebaseAuth.instance.currentUser!;
      await user.sendEmailVerification();

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: isAdmin ? kOrangeColor : kVioletShade,
          content: Text(
            'Verification email has been sent',
            style: TextStyle(color: Colors.white),
          ),
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: Colors.red,
          content: Text(
            e.toString(),
            style: TextStyle(color: Colors.white),
          ),
        ),
      );
    }
  }

//Store Token
  Future<void> storeToken({token, bool isAdmin = false}) async {
    String name = isAdmin ? "admins" : "students";

    final CollectionReference userCollection =
        FirebaseFirestore.instance.collection(name);
    FirebaseAuth auth = FirebaseAuth.instance;
    String uid = auth.currentUser!.uid.toString();

    userCollection
        .doc(uid)
        .set({
          "Info": {
            "token": token,
          }
        }, SetOptions(merge: true))
        .then((value) => print("User Token Updated"))
        .catchError((error) => print("Failed to Update Token: $error"));

    return;
  }
}
