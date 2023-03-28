// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:notice_board/helpers/constants.dart';
import 'package:notice_board/models/user_model.dart';
import 'package:notice_board/services/user_services.dart';
import 'package:provider/provider.dart';

import '../providers/user_model_provider.dart';

class UpdateInfoBottomSheet extends StatelessWidget {
  const UpdateInfoBottomSheet({
    Key? key,
    required this.header,
    required this.initialText,
  }) : super(key: key);

  final String header, initialText;

  @override
  Widget build(BuildContext context) {
    UserModelProvider userModelProvider =
        Provider.of<UserModelProvider>(context, listen: false);
    UserModel userModel = userModelProvider.currentUser;
    bool isAdmin = userModel.isAdmin;
    String updatedValue = initialText;

    var kInputDecoration = InputDecoration(
      enabledBorder: UnderlineInputBorder(
        borderSide: BorderSide(color: mainColor(context)),
      ),
      focusedBorder: UnderlineInputBorder(
        borderSide: BorderSide(color: mainColor(context)),
      ),
      border: UnderlineInputBorder(
        borderSide: BorderSide(color: mainColor(context)),
      ),
    );

    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            header,
            style: TextStyle(
              color: mainColor(context),
              fontSize: 22,
              fontWeight: FontWeight.w500,
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: TextFormField(
              onChanged: (value) {
                updatedValue = value;
              },
              keyboardType: TextInputType.name,
              onSaved: (val) {
                // print("submitted $val");
              },
              initialValue: initialText,
              style: TextStyle(color: Colors.black, fontSize: 18),
              cursorHeight: 20,
              cursorColor: mainColor(context),
              autofocus: true,
              textAlign: TextAlign.left,
              decoration: kInputDecoration,
            ),
          ),
          const SizedBox(height: 30),
          Padding(
            padding: const EdgeInsets.only(right: 8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                InkWell(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: Text(
                    'Cancel',
                    style: TextStyle(color: Colors.grey, fontSize: 18),
                  ),
                ),
                SizedBox(width: 45),
                InkWell(
                  onTap: () async {
                    // String name = updatedValue;

                    // String imageUrl = userModel.imageUrl.toString();

                    // String branch = userModel.branch.toString();

                    // String year = userModel.year.toString();

                    // String adminCategory = userModel.adminCategory.toString();

                    if (header == 'Enter Name') {
                      userModelProvider.updateUserProperty(
                          "name", updatedValue);

                      // await UserServices().updateUserDetails(
                      //   name: name,
                      //   year: year, 
                      //   imageUrl: imageUrl,
                      //   category: adminCategory,
                      //   branch: branch,
                      //   isAdmin: isAdmin,
                      // );

                      Navigator.pop(context);
                    }
                  },
                  child: Text(
                    'Save',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
