// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:notice_board/models/notice_model.dart';
import 'package:notice_board/screens/bottom_nav_screens/update_notice/update_notice_image.dart';
import 'package:provider/provider.dart';

import '../../../helpers/constants.dart';
import '../../../helpers/validators.dart';
import '../../../providers/notice_model_provider.dart';
import '../../../widgets/auth_button.dart';

class UpdateNoticeScreen extends StatefulWidget {
  const UpdateNoticeScreen({Key? key, required this.noticeModel})
      : super(key: key);

  final NoticeModel noticeModel;
  @override
  State<UpdateNoticeScreen> createState() => _UpdateNoticeScreenState();
}

class _UpdateNoticeScreenState extends State<UpdateNoticeScreen> {
  final GlobalKey<FormState> _formFieldKey = GlobalKey();

  TextEditingController _titleController = TextEditingController();
  TextEditingController _descriptionController = TextEditingController();
  TextEditingController _subjectController = TextEditingController();

  String? selectedNoticeType;
  String? selectedSubject;
  String? selectedYear;
  String? selectedBranch;

  @override
  void initState() {
    _titleController = TextEditingController(text: widget.noticeModel.title);
    _descriptionController =
        TextEditingController(text: widget.noticeModel.description);
    _subjectController =
        TextEditingController(text: widget.noticeModel.subject);

    selectedNoticeType = widget.noticeModel.noticeType;
    selectedSubject = widget.noticeModel.subject;
    selectedYear = widget.noticeModel.year;
    selectedBranch = widget.noticeModel.branch;

    super.initState();
  }

  void updateDetails(BuildContext context) {
    NoticeModelProvider noticeModelProvider =
        Provider.of<NoticeModelProvider>(context, listen: false);

    noticeModelProvider.updateNoticeProperty(
        "title", _titleController.value.text);
    noticeModelProvider.updateNoticeProperty(
        "description", _descriptionController.value.text);
    // noticeModelProvider.updateNoticeProperty(
    //     "link", _linkController.value.text);
    noticeModelProvider.updateNoticeProperty(
        "subject", _subjectController.value.text);
    noticeModelProvider.updateNoticeProperty("noticeType", selectedNoticeType);
    // noticeModelProvider.updateNoticeProperty("ownerUid", ownerUid);
    noticeModelProvider.updateNoticeProperty("branch", selectedBranch);
    noticeModelProvider.updateNoticeProperty("year", selectedYear);
    // noticeModelProvider.updateNoticeProperty("tags", chips);

    // Provider.of<NoticeModel1Provider>(context, listen: false)
    //     .updateTitle(_titleController.text);

    // Provider.of<NoticeModel1Provider>(context, listen: false)
    //     .updateDescription(_descriptionController.text);

    // Provider.of<NoticeModel1Provider>(context, listen: false)
    //     .updateSubject(_subjectController.text);

    // Provider.of<NoticeModel1Provider>(context, listen: false)
    //     .updateYear(selectedYear);

    // Provider.of<NoticeModel1Provider>(context, listen: false)
    //     .updateNoticeType(selectedNoticeType);

    // Provider.of<NoticeModel1Provider>(context, listen: false)
    //     .updateBranch(selectedBranch);
  }

  @override
  Widget build(BuildContext context) {
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

    // DropdownMenuItem<String> buildSubjectCategory(String subject) =>
    //     DropdownMenuItem(
    //       value: subject,
    //       child: Padding(
    //         padding: const EdgeInsets.only(left: 8.0),
    //         child: Text(subject),
    //       ),
    //     );

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
        title: Text(
          "Update Notice",
          style: TextStyle(color: Colors.black),
        ),
        iconTheme: IconThemeData(color: Colors.black),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 18.0).copyWith(top: 8),
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
                      validator: myValidator(requiredField: "Description"),
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
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                    ),
                    SizedBox(height: 5),
                    Container(
                      decoration: BoxDecoration(
                        border: Border.all(color: kOrangeShade2, width: 2),
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
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                    ),
                    SizedBox(height: 5),
                    Container(
                      decoration: BoxDecoration(
                        border: Border.all(color: kOrangeShade2, width: 2),
                        borderRadius: BorderRadius.circular(7),
                      ),
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton<String>(
                          hint: Padding(
                            padding: const EdgeInsets.only(left: 8.0),
                            child: Text("Choose Branch"),
                          ),
                          isExpanded: true,
                          items: shortBranch.map(buildBranchCategory).toList(),
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
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                    ),
                    SizedBox(height: 5),
                    Container(
                      decoration: BoxDecoration(
                        border: Border.all(color: kOrangeShade2, width: 2),
                        borderRadius: BorderRadius.circular(7),
                      ),
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton<String>(
                          hint: Padding(
                            padding: const EdgeInsets.only(left: 8.0),
                            child: Text("Choose Category"),
                          ),
                          isExpanded: true,
                          items:
                              noticeType.map(buildNoticeTypeCategory).toList(),
                          onChanged: (value) {
                            setState(() {
                              selectedNoticeType = value;
                            });
                          },
                          value: selectedNoticeType,
                        ),
                      ),
                    ),
                    SizedBox(height: 30),
                    Center(
                      child: AuthButton(
                        color: kOrangeColor,
                        size: size,
                        name: "Next",
                        onTap: () {
                          if (_formFieldKey.currentState!.validate()) {
                            if (!condition) {
                              return ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  backgroundColor: Colors.redAccent,
                                  content: Text(
                                    'Please fill all required field',
                                    style: TextStyle(color: Colors.white),
                                  ),
                                ),
                              );
                            } else {
                              updateDetails(context);
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => UpdateNoticeImage(
                                    noticeModel: widget.noticeModel,
                                  ),
                                ),
                              );
                            }
                          }
                        },
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
    );
  }
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
