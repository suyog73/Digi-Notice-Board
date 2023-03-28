import 'package:email_auth/email_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:lottie/lottie.dart';
import 'package:notice_board/helpers/validators.dart';
import 'package:notice_board/widgets/my_appbar.dart';
import 'package:notice_board/widgets/my_button.dart';
import 'package:notice_board/widgets/my_text_input.dart';

class OrganisationScreen extends StatelessWidget {
  const OrganisationScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    EmailAuth emailAuth = EmailAuth(sessionName: "Sample session");

    TextEditingController textEditingController = TextEditingController();
    TextEditingController emailController = TextEditingController();
    int size = 0;

    return Scaffold(
      appBar: const MyAppBar(appBarName: "Register Organisation"),
      body: Column(
        children: [
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.45,
            child: Lottie.asset("assets/lottie/org.json"),
          ),
          const SizedBox(height: 10),
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 18.0),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        "Super Admin Registration",
                        style: TextStyle(fontSize: 18),
                        textAlign: TextAlign.start,
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  MyTextInput(
                    hintText: "Organisation name",
                    icon: FontAwesomeIcons.building,
                    controller: textEditingController,
                    validator: myValidator(requiredField: "Organisation name"),
                    isAdmin: false,
                    textInputType: TextInputType.name,
                  ),
                  const SizedBox(height: 10),
                  MyTextInput(
                    hintText: "Email (Organisation email only)",
                    icon: Icons.mail,
                    controller: textEditingController,
                    validator: myValidator(requiredField: "Organisation name"),
                    isAdmin: false,
                    textInputType: TextInputType.name,
                  ),
                  const SizedBox(height: 10),
                  MyTextInput(
                    hintText: "Organisation size",
                    icon: Icons.people,
                    controller: textEditingController,
                    validator: myValidator(requiredField: "Organisation name"),
                    isAdmin: false,
                    textInputType: TextInputType.number,
                  ),
                  const SizedBox(height: 10),
                  InkWell(
                    onTap: () {
                      void sendOtp() async {
                        bool result = await emailAuth
                            .sendOtp(
                          recipientMail: emailController.value.text,
                          otpLength: 5,
                        )
                            .then((value) {
                          if (value) {
                          } else {
                            const SnackBar(content: Text("Unable to send otp"));
                          }
                          return false;
                        });
                      }
                    },
                    child: const MyButton(text: "Validate"),
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
