// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:notice_board/helpers/constants.dart';
import 'package:notice_board/helpers/validators.dart';
import 'package:notice_board/models/user_model.dart';
import 'package:notice_board/providers/user_model_provider.dart';
import 'package:notice_board/screens/auth_screens/student_signup_screen.dart';
import 'package:notice_board/services/get_admin_data.dart';
import 'package:notice_board/services/user_services.dart';
import 'package:notice_board/widgets/auth_text_field.dart';
import 'package:notice_board/screens/auth_screens/admin_login_screen.dart';
import 'package:provider/provider.dart';
import '../../services/auth_helper.dart';
import '../../widgets/auth_button.dart';

class AdminSignupScreen extends StatefulWidget {
  const AdminSignupScreen({Key? key}) : super(key: key);

  @override
  State<AdminSignupScreen> createState() => _AdminSignupScreenState();
}

class _AdminSignupScreenState extends State<AdminSignupScreen> {
  final GlobalKey<FormState> _formFieldKey = GlobalKey();

  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController cPasswordController = TextEditingController();

  bool showSpinner = false;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: kOrangeShade2,
        title: Text(
          "Admin SignUp",
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
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(height: size.height * 0.1),
                    Text(
                      "SignUp",
                      style:
                          TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(18.0),
                      child: Text(
                        "Make sure you have admin access to signup as a admin",
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 18, color: Colors.grey),
                      ),
                    ),
                    SizedBox(height: 20),
                    AuthTextField(
                      isAdmin: true,
                      name: 'Name',
                      controller: nameController,
                      icon: FontAwesomeIcons.user,
                      validator: nameValidator,
                    ),
                    SizedBox(height: 20),
                    AuthTextField(
                      isAdmin: true,
                      name: 'Email',
                      controller: emailController,
                      icon: Icons.mail,
                      validator: emailValidator,
                    ),
                    SizedBox(height: 20),
                    AuthTextField(
                      isAdmin: true,
                      name: 'Password',
                      controller: passwordController,
                      icon: Icons.vpn_key,
                      validator: passwordValidator,
                      isPassword: true,
                    ),
                    SizedBox(height: 25),
                    AuthTextField(
                      isAdmin: true,
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
                      color: kOrangeColor,
                      size: size,
                      name: 'SignUp',
                      onTap: () async {
                        if (_formFieldKey.currentState!.validate()) {
                          setState(() {
                            showSpinner = true;
                          });
                          await AuthHelper()
                              .signUp(
                            email: emailController.text,
                            password: passwordController.text,
                            isAdmin: true,
                          )
                              .then((result) async {
                            if (result == null) {
                              // setState(() {
                              //   UserModel.isAdmin = true;
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
                                prn: '',
                                uid: '',
                                year: '',
                              );

                              Provider.of<UserModelProvider>(context,
                                      listen: false)
                                  .createNewUser(userModel, true);

                              // await UserServices().storeUserDetails(
                              //   name: nameController.text,
                              //   email: emailController.text,
                              //   // password: passwordController.text,
                              //   isAdmin: true,
                              // );

                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => GetAdminData(),
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
                                builder: (context) => AdminLoginScreen(),
                              ),
                            );
                          },
                          child: Text(
                            " Login",
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
                            builder: (context) => StudentSignupScreen(),
                          ),
                        );
                      },
                      child: NavigateButton(
                        color: kVioletShade,
                        text: "SignUp as a Student",
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
