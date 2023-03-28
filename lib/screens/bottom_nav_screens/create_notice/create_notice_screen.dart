// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors

import 'dart:math';

import 'package:flutter/material.dart';
import 'package:notice_board/helpers/constants.dart';
import 'package:notice_board/helpers/validators.dart';
import 'package:notice_board/providers/notice_model_provider.dart';
import 'package:notice_board/providers/user_model_provider.dart';
import 'package:notice_board/screens/bottom_nav_screens/create_notice/create_notice_image_screen.dart';
import 'package:notice_board/widgets/auth_button.dart';
import 'package:provider/provider.dart';

import '../../../models/input_chip_model.dart';

class CreateNoticeScreen extends StatefulWidget {
  const CreateNoticeScreen({Key? key}) : super(key: key);

  @override
  State<CreateNoticeScreen> createState() => _CreateNoticeScreenState();
}

class _CreateNoticeScreenState extends State<CreateNoticeScreen> {
  final GlobalKey<FormState> _formFieldKey = GlobalKey();

  final double spacing = 8;
  List<InputChipData> inputChips = InputChips.all;
  List<String> chips = [];

  String? selectedNoticeType;
  String? selectedSubject;
  String? selectedYear;
  String? selectedBranch;

  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _linkController = TextEditingController();
  final TextEditingController _subjectController = TextEditingController();
  final TextEditingController _tagController = TextEditingController();

  void setAllVariables(BuildContext context) {
    NoticeModelProvider noticeModelProvider =
        Provider.of<NoticeModelProvider>(context, listen: false);

    UserModelProvider userModelProvider =
        Provider.of<UserModelProvider>(context, listen: false);

    String ownerUid = userModelProvider.currentUser.uid.toString();

    noticeModelProvider.updateNoticeProperty(
        "title", _titleController.value.text);
    noticeModelProvider.updateNoticeProperty(
        "description", _descriptionController.value.text);
    noticeModelProvider.updateNoticeProperty(
        "link", _linkController.value.text);
    noticeModelProvider.updateNoticeProperty(
        "subject", _subjectController.value.text);
    noticeModelProvider.updateNoticeProperty("noticeType", selectedNoticeType);
    noticeModelProvider.updateNoticeProperty("ownerUid", ownerUid);
    noticeModelProvider.updateNoticeProperty("branch", selectedBranch);
    noticeModelProvider.updateNoticeProperty("year", selectedYear);
    noticeModelProvider.updateNoticeProperty("tags", chips);
  }

  @override
  Widget build(BuildContext context) {
    // UserModelProvider userModelProvider =
    //     Provider.of<UserModelProvider>(context);

    final condition = (selectedYear != null && selectedYear != "") &&
        (selectedBranch != null && selectedBranch != "") &&
        (selectedNoticeType != null && selectedNoticeType != "");

    Size size = MediaQuery.of(context).size;

    DropdownMenuItem<String> buildNoticeTypeCategory(String category) =>
        DropdownMenuItem(
          value: category,
          child: Padding(
            padding: const EdgeInsets.only(left: 8.0),
            child: Text(category),
          ),
        );

    DropdownMenuItem<String> buildYearCategory(String year) => DropdownMenuItem(
          value: year,
          child: Padding(
            padding: const EdgeInsets.only(left: 8.0),
            child: Text(year),
          ),
        );

    DropdownMenuItem<String> buildBranchCategory(String branch) =>
        DropdownMenuItem(
          value: branch,
          child: Padding(
            padding: const EdgeInsets.only(left: 8.0),
            child: Text(branch),
          ),
        );

    return Scaffold(
      appBar: AppBar(
        backgroundColor: kOrangeShade2,
        title: Text("Create Notices"),
      ),
      body: Column(
        children: [
          SizedBox(height: 30),
          Container(
            alignment: Alignment.center,
            // height: size.height * 0.2,
            child: Text(
              "Fill the details",
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
          ),
          Expanded(
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 18.0).copyWith(top: 8),
              child: Container(
                decoration: BoxDecoration(
                    // border: Border.all(color: kOrangeShade, width: 2),
                    ),
                child: Padding(
                  padding: const EdgeInsets.all(18.0),
                  child: SingleChildScrollView(
                    physics: BouncingScrollPhysics(),
                    child: Form(
                      key: _formFieldKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          UploadTextField(
                            lines: 1,
                            hint: "Title*",
                            controller: _titleController,
                            validator: myValidator(requiredField: "Title"),
                          ),
                          SizedBox(height: 15),
                          UploadTextField(
                            lines: 7,
                            hint: 'Description*',
                            controller: _descriptionController,
                            validator:
                                myValidator(requiredField: "Description"),
                          ),
                          SizedBox(height: 15),
                          UploadTextField(
                            lines: 1,
                            hint: 'External Link',
                            controller: _linkController,
                            validator: null,
                          ),
                          SizedBox(height: 15),
                          UploadTextField(
                            lines: 1,
                            hint: 'Subject*',
                            controller: _subjectController,
                            validator: myValidator(requiredField: "Subject"),
                          ),
                          SizedBox(height: 15),
                          Text(
                            "Year*",
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.w600),
                          ),
                          SizedBox(height: 5),
                          Container(
                            decoration: BoxDecoration(
                              border:
                                  Border.all(color: kOrangeShade2, width: 2),
                              borderRadius: BorderRadius.circular(7),
                            ),
                            child: DropdownButtonHideUnderline(
                              child: DropdownButton<String>(
                                hint: Padding(
                                  padding: const EdgeInsets.only(left: 8.0),
                                  child: Text("Choose Year"),
                                ),
                                isExpanded: true,
                                items: year.map(buildYearCategory).toList(),
                                onChanged: (value) {
                                  setState(() {
                                    selectedYear = value;
                                  });
                                },
                                value: selectedYear,
                              ),
                            ),
                          ),
                          SizedBox(height: 15),
                          Text(
                            "Branch*",
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.w600),
                          ),
                          SizedBox(height: 5),
                          Container(
                            decoration: BoxDecoration(
                              border:
                                  Border.all(color: kOrangeShade2, width: 2),
                              borderRadius: BorderRadius.circular(7),
                            ),
                            child: DropdownButtonHideUnderline(
                              child: DropdownButton<String>(
                                hint: Padding(
                                  padding: const EdgeInsets.only(left: 8.0),
                                  child: Text("Choose Branch"),
                                ),
                                isExpanded: true,
                                items: shortBranch
                                    .map(buildBranchCategory)
                                    .toList(),
                                onChanged: (value) {
                                  setState(() {
                                    selectedBranch = value;
                                  });
                                },
                                value: selectedBranch,
                              ),
                            ),
                          ),
                          SizedBox(height: 15),
                          Text(
                            "Notice Type*",
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.w600),
                          ),
                          SizedBox(height: 5),
                          Container(
                            decoration: BoxDecoration(
                              border:
                                  Border.all(color: kOrangeShade2, width: 2),
                              borderRadius: BorderRadius.circular(7),
                            ),
                            child: DropdownButtonHideUnderline(
                              child: DropdownButton<String>(
                                hint: Padding(
                                  padding: const EdgeInsets.only(left: 8.0),
                                  child: Text("Choose Category"),
                                ),
                                isExpanded: true,
                                items: noticeType
                                    .map(buildNoticeTypeCategory)
                                    .toList(),
                                onChanged: (value) {
                                  setState(() {
                                    selectedNoticeType = value;
                                  });
                                },
                                value: selectedNoticeType,
                              ),
                            ),
                          ),
                          SizedBox(height: 15),
                          UploadTextField(
                            lines: 1,
                            hint: "Add tags",
                            controller: _tagController,
                            isReq: true,
                            onTap: () {
                              setState(() {
                                InputChips.all.add(
                                    InputChipData(label: _tagController.text));
                                chips.add(_tagController.text);
                              });
                              _tagController.text = "";
                            },
                          ),
                          SizedBox(height: 15),
                          buildInputChips(),
                          SizedBox(height: 30),
                          Center(
                            child: AuthButton(
                              size: size,
                              name: "Next",
                              onTap: () {
                                if (_formFieldKey.currentState!.validate()) {
                                  // setState(() {
                                  //   // _descriptionController.notifyListeners();

                                  //   NoticeModel.title =
                                  //       _titleController.value.text;
                                  //   NoticeModel.description =
                                  //       _descriptionController.value.text;
                                  //   NoticeModel.link =
                                  //       _linkController.value.text;
                                  //   NoticeModel.subject =
                                  //       _subjectController.text;
                                  //   NoticeModel.noticeType = selectedNoticeType;
                                  //   NoticeModel.ownerUid = UserModel.name;
                                  //   NoticeModel.branch = selectedBranch;
                                  //   NoticeModel.year = selectedYear;
                                  //   NoticeModel.tags = chips;
                                  // });

                                  setAllVariables(context);
                                  if (!condition) {
                                    return ScaffoldMessenger.of(context)
                                        .showSnackBar(
                                      SnackBar(
                                        backgroundColor: Colors.redAccent,
                                        content: Text(
                                          'Please fill all required field',
                                          style: TextStyle(color: Colors.white),
                                        ),
                                      ),
                                    );
                                  } else {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            CreateNoticeImageScreen(),
                                      ),
                                    );
                                  }
                                }
                              },
                              color: kOrangeColor,
                            ),
                          ),
                          SizedBox(height: 30),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  var rng = Random();

  Widget buildInputChips() => Wrap(
        runSpacing: spacing,
        spacing: spacing,
        children: inputChips
            .map((inputChip) => InputChip(
                  backgroundColor: Colors.black.withOpacity(0.1),
                  label: Text(inputChip.label),
                  labelStyle: TextStyle(
                      fontWeight: FontWeight.bold, color: Colors.black),
                  onPressed: () {},
                  onDeleted: () {
                    setState(() {
                      inputChips.remove(inputChip);
                      chips.remove(inputChip.label);
                    });
                  },
                ))
            .toList(),
      );
}

class UploadTextField extends StatelessWidget {
  const UploadTextField({
    Key? key,
    required this.lines,
    required this.hint,
    required this.controller,
    this.validator,
    this.minLines = 1,
    this.isReq = false,
    this.onTap,
  }) : super(key: key);

  final int lines, minLines;
  final String hint;
  final TextEditingController controller;
  final FormFieldValidator? validator;
  final bool isReq;
  final Function? onTap;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          hint,
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
        ),
        SizedBox(height: 5),
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: TextFormField(
                minLines: minLines,
                maxLines: lines,
                controller: controller,
                validator: validator,
                decoration: InputDecoration(
                  focusColor: Colors.red,
                  fillColor: Colors.red,
                  hintText: hint,
                  border: OutlineInputBorder(
                    borderSide:
                        const BorderSide(color: kOrangeShade2, width: 2.0),
                    borderRadius: BorderRadius.all(
                      Radius.circular(7),
                    ),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide:
                        const BorderSide(color: kOrangeShade2, width: 2.0),
                    borderRadius: BorderRadius.all(Radius.circular(7)),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide:
                        const BorderSide(color: kOrangeShade2, width: 2.0),
                    borderRadius: BorderRadius.all(
                      Radius.circular(7),
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(width: 10),
            if (isReq)
              Center(
                child: InkWell(
                  onTap: () {
                    onTap!();
                  },
                  child: Container(
                    alignment: Alignment.center,
                    height: 50,
                    width: 50,
                    decoration: BoxDecoration(
                      color: kOrangeShade2,
                      borderRadius: BorderRadius.circular(300),
                    ),
                    child: Text("Add"),
                  ),
                ),
              ),
          ],
        ),
      ],
    );
  }
}
