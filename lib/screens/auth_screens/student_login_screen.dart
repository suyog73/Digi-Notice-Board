// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:lottie/lottie.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:notice_board/helpers/constants.dart';
import 'package:notice_board/helpers/validators.dart';
import 'package:notice_board/models/user_model.dart';
import 'package:notice_board/screens/auth_screens/reset_password_screen.dart';
import 'package:notice_board/widgets/auth_text_field.dart';
import 'package:notice_board/screens/auth_screens/student_signup_screen.dart';
import 'package:notice_board/services/auth_helper.dart';
import 'package:notice_board/services/get_student_data.dart';
import '../../widgets/auth_button.dart';
import 'admin_login_screen.dart';

class StudentLoginScreen extends StatefulWidget {
  const StudentLoginScreen({Key? key}) : super(key: key);

  @override
  State<StudentLoginScreen> createState() => _StudentLoginScreenState();
}

class _StudentLoginScreenState extends State<StudentLoginScreen> {
  final GlobalKey<FormState> _formFieldKey = GlobalKey();

  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  bool showSpinner = false;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: kVioletShade,
        title: Text("Student Login"),
      ),
      body: ModalProgressHUD(
        inAsyncCall: showSpinner,
        progressIndicator: CircularProgressIndicator(color: kVioletShade),
        child: Center(
          child: Form(
            key: _formFieldKey,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32.0),
              child: SingleChildScrollView(
                physics: BouncingScrollPhysics(),
                child: Column(
                  children: [
                    Lottie.asset('assets/lottie/login.json',
                        height: size.height * 0.4),
                    SizedBox(height: 30),
                    Text(
                      "Login",
                      style:
                          TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 20),
                    AuthTextField(
                      name: 'Email',
                      controller: emailController,
                      icon: Icons.mail,
                      validator: emailValidator,
                    ),
                    SizedBox(height: 25),
                    AuthTextField(
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
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    ResetPasswordScreen(isAdmin: false),
                              ),
                            );
                          },
                          child: Text(
                            "Forget Password?",
                            // style: TextStyle(color: kLightBlueShadeColor),
                          ),
                        )
                      ],
                    ),
                    SizedBox(height: 30),
                    AuthButton(
                      size: size,
                      name: 'Login',
                      textColor: Colors.white,
                      color: kVioletShade,
                      onTap: () async {
                        if (_formFieldKey.currentState!.validate()) {
                          FocusScope.of(context).unfocus();

                          setState(() {
                            showSpinner = true;
                          });
                          await AuthHelper()
                              .signIn(
                                  email: emailController.text,
                                  password: passwordController.text)
                              .then((result) {
                            if (result == null) {
                              // setState(() {
                              //   UserModel.isAdmin = false;
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
                                builder: (context) => StudentSignupScreen(),
                              ),
                            );
                          },
                          child: Text(
                            " Sign Up",
                            style: TextStyle(
                              fontSize: 16,
                              color: kVioletShade,
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
                            builder: (context) => AdminLoginScreen(),
                          ),
                        );
                      },
                      child: NavigateButton(
                        color: kOrangeColor,
                        text: "Login as a Admin",
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
