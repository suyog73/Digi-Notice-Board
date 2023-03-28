// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:notice_board/helpers/constants.dart';
import 'package:notice_board/helpers/validators.dart';
import 'package:notice_board/models/user_model.dart';
import 'package:notice_board/screens/auth_screens/admin_signup_screen.dart';
import 'package:notice_board/widgets/auth_text_field.dart';
import 'package:notice_board/screens/auth_screens/student_login_screen.dart';
import 'package:notice_board/services/get_student_data.dart';
import 'package:provider/provider.dart';
import '../../providers/user_model_provider.dart';
import '../../services/auth_helper.dart';
import '../../services/user_services.dart';
import '../../widgets/auth_button.dart';
import 'admin_login_screen.dart';

class StudentSignupScreen extends StatefulWidget {
  const StudentSignupScreen({Key? key}) : super(key: key);

  @override
  State<StudentSignupScreen> createState() => _StudentSignupScreenState();
}

class _StudentSignupScreenState extends State<StudentSignupScreen> {
  final GlobalKey<FormState> _formFieldKey = GlobalKey();

  TextEditingController nameController = TextEditingController();
  TextEditingController prnController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController cPasswordController = TextEditingController();

  bool showSpinner = false;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: kVioletShade,
        title: Text("Student SignUp"),
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
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(height: size.height * 0.1),
                    Text(
                      "SignUp",
                      style:
                          TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 20),
                    AuthTextField(
                      name: 'Name',
                      controller: nameController,
                      icon: FontAwesomeIcons.user,
                      validator: nameValidator,
                    ),
                    SizedBox(height: 20),
                    AuthTextField(
                      name: 'PRN',
                      controller: prnController,
                      icon: Icons.verified_user_sharp,
                      validator: prnValidator,
                    ),
                    SizedBox(height: 20),
                    AuthTextField(
                      name: 'Email',
                      controller: emailController,
                      icon: Icons.mail,
                      validator: (val) {
                        val = val.toString();
                        // print(val);
                        if (val.length < 21) {
                          return "Please enter college email address";
                        }

                        String tp = val.substring(val.length - 21, val.length);
                        // print("tp == ${tp.length}");
                        String clgEmailId = "@walchandsangli.ac.in";
                        // print("tp == ${clgEmailId.length}");

                        if (tp != clgEmailId) {
                          return "Please enter college email address";
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 20),
                    AuthTextField(
                      name: 'Password',
                      controller: passwordController,
                      icon: Icons.vpn_key,
                      validator: passwordValidator,
                      isPassword: true,
                    ),
                    SizedBox(height: 25),
                    AuthTextField(
                      name: 'Confirm Password',
                      controller: cPasswordController,
                      icon: Icons.vpn_key,
                      isPassword: true,
                      validator: (value) {
                        if (value != passwordController.text) {
                          return "Confirm password and password doesn't match";
                        }
                        return null;
                      },
                      textInputAction: TextInputAction.done,
                    ),
                    SizedBox(height: 30),
                    AuthButton(
                      size: size,
                      name: 'SignUp',
                      color: kVioletShade,
                      onTap: () async {
                        if (_formFieldKey.currentState!.validate()) {
                          setState(() {
                            showSpinner = true;
                          });
                          await AuthHelper()
                              .signUp(
                            email: emailController.text,
                            password: passwordController.text,
                          )
                              .then((result) async {
                            if (result == null) {
                              // setState(() {
                              //   UserModel.isAdmin = false;
                              // });

                              UserModel userModel = UserModel(
                                bookmarkNotices: [],
                                isAdmin: true,
                                adminCategory: '',
                                branch: '',
                                email: emailController.text,
                                imageUrl: '',
                                name: nameController.text,
                                passOutYear: '',
                                prn: prnController.text,
                                uid: '',
                                year: '',
                              );

                              Provider.of<UserModelProvider>(context,
                                      listen: false)
                                  .createNewUser(userModel, false);

                              // await UserServices().storeUserDetails(
                              //   name: nameController.text,
                              //   prn: prnController.text,
                              //   email: emailController.text,
                              //   // password: passwordController.text,
                              // );

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
                              Fluttertoast.showToast(
                                  msg: result, backgroundColor: Colors.red);
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
                          "Already have an account?",
                          style: TextStyle(fontSize: 16),
                        ),
                        InkWell(
                          onTap: () {
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                builder: (context) => StudentLoginScreen(),
                              ),
                            );
                          },
                          child: Text(
                            " Login",
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
                            builder: (context) => AdminSignupScreen(),
                          ),
                        );
                      },
                      child: NavigateButton(
                        color: kOrangeColor,
                        text: "SignUp as a Admin",
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
