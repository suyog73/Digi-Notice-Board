// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:lottie/lottie.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:notice_board/helpers/constants.dart';
import 'package:notice_board/screens/auth_screens/reset_password_screen.dart';
import 'package:notice_board/screens/auth_screens/student_login_screen.dart';
import 'package:notice_board/widgets/auth_text_field.dart';
import 'package:notice_board/screens/auth_screens/admin_signup_screen.dart';
import 'package:notice_board/services/get_student_data.dart';
import '../../models/user_model.dart';
import '../../services/auth_helper.dart';
import '../../widgets/auth_button.dart';

class AdminLoginScreen extends StatefulWidget {
  const AdminLoginScreen({Key? key}) : super(key: key);

  @override
  State<AdminLoginScreen> createState() => _AdminLoginScreenState();
}

class _AdminLoginScreenState extends State<AdminLoginScreen> {
  final GlobalKey<FormState> _formFieldKey = GlobalKey();

  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  bool showSpinner = false;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: kOrangeShade2,
        title: Text(
          "Admin Login",
          style: TextStyle(color: Colors.black),
        ),
        iconTheme: IconThemeData(color: Colors.black),
      ),
      body: ModalProgressHUD(
        inAsyncCall: showSpinner,
        progressIndicator: CircularProgressIndicator(color: kOrangeColor),
        child: Center(
          child: Form(
            key: _formFieldKey,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32.0),
              child: SingleChildScrollView(
                physics: BouncingScrollPhysics(),
                child: Column(
                  children: [
                    SizedBox(height: 20),
                    Lottie.asset('assets/lottie/teacher.json',
                        height: size.height * 0.4),
                    SizedBox(height: 30),
                    Text(
                      "Login",
                      style:
                          TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(18.0),
                      child: Text(
                        "Make sure you have admin access to login as a admin",
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 18, color: Colors.grey),
                      ),
                    ),
                    SizedBox(height: 20),
                    AuthTextField(
                      isAdmin: true,
                      name: 'Email',
                      controller: emailController,
                      icon: Icons.mail,
                    ),
                    SizedBox(height: 25),
                    AuthTextField(
                      isAdmin: true,
                      name: 'Password',
                      controller: passwordController,
                      icon: Icons.vpn_key,
                      textInputAction: TextInputAction.done,
                      isPassword: true,
                    ),
                    SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        InkWell(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    ResetPasswordScreen(isAdmin: true),
                              ),
                            );
                          },
                          child: Text(
                            "Forget Password?",
                            // style: TextStyle(
                            //   color: kLightBlueShadeColor,
                            //   fontWeight: FontWeight.bold,
                            // ),
                          ),
                        )
                      ],
                    ),
                    SizedBox(height: 30),
                    AuthButton(
                      color: kOrangeColor,
                      size: size,
                      name: 'Login',
                      onTap: () async {
                        if (_formFieldKey.currentState!.validate()) {
                          FocusScope.of(context).unfocus();

                          setState(() {
                            showSpinner = true;
                          });
                          await AuthHelper()
                              .signIn(
                            email: emailController.text,
                            password: passwordController.text,
                            isAdmin: true,
                          )
                              .then((result) {
                            if (result == null) {
                              // setState(() {
                              //   UserModel.isAdmin = true;
                              // });

                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => GetStudentData(),
                                ),
                              );
                            } else {
                              setState(() {
                                showSpinner = false;
                              });
                              Fluttertoast.showToast(msg: result);
                            }
                          });
                          setState(() {
                            showSpinner = false;
                          });
                        }
                      },
                    ),
                    SizedBox(height: 35),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Don't have an account?",
                          style: TextStyle(fontSize: 16),
                        ),
                        InkWell(
                          onTap: () {
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                builder: (context) => AdminSignupScreen(),
                              ),
                            );
                          },
                          child: Text(
                            " Sign Up",
                            style: TextStyle(
                              fontSize: 16,
                              color: kOrangeColor,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 35),
                    InkWell(
                      onTap: () {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) => StudentLoginScreen(),
                          ),
                        );
                      },
                      child: NavigateButton(
                        color: kVioletShade,
                        text: "Login as a Student",
                      ),
                    ),
                    SizedBox(height: 35),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class NavigateButton extends StatelessWidget {
  const NavigateButton({
    Key? key,
    required this.text,
    required this.color,
  }) : super(key: key);

  final String text;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 7),
      decoration: BoxDecoration(
        border: Border.all(color: color, width: 2),
        borderRadius: BorderRadius.circular(7),
      ),
      child: Text(
        text,
        style: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.bold,
          color: color,
        ),
      ),
    );
  }
}
