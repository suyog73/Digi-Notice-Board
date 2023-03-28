// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import '../helpers/constants.dart';

class MyTextInput extends StatefulWidget {
  const MyTextInput({
    Key? key,
    required this.hintText,
    required this.icon,
    required this.controller,
    required this.validator,
    required this.isAdmin,
    this.textInputAction = TextInputAction.next,
    required this.textInputType,
  }) : super(key: key);

  final String hintText;
  final IconData icon;
  final TextEditingController controller;
  final FormFieldValidator? validator;
  final TextInputAction textInputAction;
  final bool isAdmin;
  final TextInputType textInputType;

  @override
  State<MyTextInput> createState() => _MyTextInputState();
}

class _MyTextInputState extends State<MyTextInput> {
  @override
  Widget build(BuildContext context) {
    Color _mainColor = widget.isAdmin ? kOrangeColor : kVioletShade;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 32),
      child: Stack(
        children: [
          Container(
            height: 54,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(27),
              color: Colors.grey.shade100,
              border: Border.all(color: Colors.grey.shade700.withOpacity(0.15)),
            ),
          ),
          TextFormField(
            style: TextStyle(
              color: Colors.black,
              fontSize: 16,
            ),
            decoration: kTextFormFieldAuthDec.copyWith(
              hintText: widget.hintText,
              prefixIcon: Icon(
                widget.icon,
                color: _mainColor,
              ),
              errorStyle: TextStyle(color: kGreenShadeColor),
            ),
            keyboardType: widget.textInputType,
            textInputAction: widget.textInputAction,
            cursorColor: _mainColor,
            controller: widget.controller,
            onSaved: (value) {
              widget.controller.value =
                  widget.controller.value.copyWith(text: value);
            },
            validator: widget.validator,
          ),
        ],
      ),
    );
  }
}
