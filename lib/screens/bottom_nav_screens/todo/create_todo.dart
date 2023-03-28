// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';

import 'package:notice_board/helpers/constants.dart';
import 'package:notice_board/helpers/validators.dart';
import 'package:notice_board/screens/bottom_nav_screens/update_notice/update_notice_screen.dart';
import 'package:notice_board/services/date_time_api.dart';
import 'package:notice_board/services/todo_helper.dart';
import 'package:notice_board/widgets/my_button.dart';

class CreateTodo extends StatefulWidget {
  const CreateTodo({Key? key, this.myTodo, this.type, this.isUpdate = false})
      : super(key: key);

  @override
  State<CreateTodo> createState() => _CreateTodoState();

  final String? myTodo, type;
  final bool isUpdate;
}

class _CreateTodoState extends State<CreateTodo> {
  TextEditingController _todoController = TextEditingController();
  TextEditingController _typeController = TextEditingController();

  DateTime dateTime = DateTime(2000);

  bool isReminder = false;
  bool showSpinner = false;

  String? selectedTodo;

  @override
  void initState() {
    _todoController = TextEditingController(text: widget.myTodo);
    _typeController = TextEditingController(text: widget.type);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    DropdownMenuItem<String> buildTodoTag(String category) => DropdownMenuItem(
          value: category,
          child: Padding(
            padding: const EdgeInsets.only(left: 8.0),
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: tagColor[category],
                borderRadius: BorderRadius.circular(5),
              ),
              child: Text(category),
            ),
          ),
        );

    final day = dateTime.day.toString().padLeft(2, '0');
    final month = dateTime.month.toString().padLeft(2, '0');
    final year = dateTime.year.toString().padLeft(4, '0');
    final hours = dateTime.hour.toString().padLeft(2, '0');
    final minutes = dateTime.minute.toString().padLeft(2, '0');

    return ModalProgressHUD(
      inAsyncCall: showSpinner,
      progressIndicator: CircularProgressIndicator(color: mainColor(context)),
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: mainColor(context),
          title: Text(
            "Add Todo",
            style: TextStyle(color: textColor(context)),
          ),
          iconTheme: IconThemeData(color: textColor(context)),
        ),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 18.0, vertical: 8),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 15),
                Center(
                  child: Text(
                    "Add todo and forget it. We will notify you!",
                    style: TextStyle(fontSize: 18),
                  ),
                ),
                SizedBox(height: 30),
                UploadTextField(
                  lines: 1,
                  hint: "Type of Todo*",
                  controller: _typeController,
                  validator: myValidator(requiredField: "Type of Todo"),
                ),
                SizedBox(height: 15),
                UploadTextField(
                  lines: 1,
                  hint: "Add todo*",
                  controller: _todoController,
                  validator: myValidator(requiredField: "Todo"),
                ),
                SizedBox(height: 15),
                Text(
                  "Choose priority of this todo",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
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
                        child: Text("Choose priority"),
                      ),
                      isExpanded: true,
                      items: todoTags.map(buildTodoTag).toList(),
                      onChanged: (value) {
                        setState(() {
                          selectedTodo = value;
                        });
                      },
                      value: selectedTodo,
                    ),
                  ),
                ),
                SizedBox(height: 15),
                Row(
                  children: [
                    Checkbox(
                      value: isReminder,
                      activeColor: mainColor(context),
                      checkColor: textColor(context),
                      onChanged: (bool? val) {
                        setState(() {
                          isReminder = val!;
                        });
                      },
                    ),
                    Text(
                      'Add Reminder',
                      style: TextStyle(fontSize: 18),
                    ),
                  ],
                ),
                if (isReminder) ...[
                  SizedBox(height: 15),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Date and Time*",
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.w500),
                      ),
                      SizedBox(height: 10),
                      Container(
                        height: 50,
                        width: size.width,
                        decoration: BoxDecoration(border: Border.all()),
                        child: Padding(
                          padding: const EdgeInsets.only(left: 10.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              InkWell(
                                onTap: () async {
                                  DateTime? tp = await DateTimeApi().pickDate(
                                    context,
                                    DateTime.now(),
                                  );
                                  if (tp == null) return;
                                  final newDateTime = DateTime(
                                    tp.year,
                                    tp.month,
                                    tp.day,
                                    dateTime.hour,
                                    dateTime.minute,
                                  );

                                  setState(() {
                                    dateTime = newDateTime;
                                  });
                                },
                                child: Row(
                                  children: [
                                    Icon(Icons.calendar_month),
                                    SizedBox(width: 10),
                                    Text("$day/$month/$year"),
                                  ],
                                ),
                              ),
                              SizedBox(width: 20),
                              InkWell(
                                onTap: () async {
                                  TimeOfDay? tp =
                                      await DateTimeApi().pickTime(context);

                                  if (tp == null) return;
                                  final newDateTime = DateTime(
                                    dateTime.year,
                                    dateTime.month,
                                    dateTime.day,
                                    tp.hour,
                                    tp.minute,
                                  );

                                  setState(() {
                                    dateTime = newDateTime;
                                  });
                                },
                                child: Row(
                                  children: [
                                    Icon(Icons.watch_later_outlined),
                                    SizedBox(width: 10),
                                    Text("$hours:$minutes"),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 15),
                ],
                SizedBox(height: 15),
                Center(
                  child: InkWell(
                    onTap: () async {
                      FocusScope.of(context).unfocus();

                      setState(() {
                        showSpinner = true;
                      });
                      if (widget.isUpdate == false) {
                        await TodoHelper()
                            .storeTodoDetails(
                          myTodo: _todoController.text,
                          type: _typeController.text,
                          reminder: dateTime,
                          priority: selectedTodo ?? "",
                        )
                            .then((value) {
                          Navigator.pop(context);
                        });
                      } else {
                        TodoHelper().updateTodoDetails(
                          myTodo: _todoController.text,
                          type: _typeController.text,
                          priority: selectedTodo.toString(),
                          reminder: dateTime,
                        );
                      }
                      setState(() {
                        showSpinner = false;
                      });
                    },
                    child: MyButton1(
                      text: "Add",
                      color: mainColor(context),
                      borderRadius: 8,
                      textColor: textColor(context),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
