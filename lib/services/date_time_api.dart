// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:notice_board/helpers/constants.dart';

class DateTimeApi {
  DateTime dateTime = DateTime.now();

  Future<DateTime?> pickDate(BuildContext context, DateTime initialDate) async {
    final startDate = initialDate;
    final DateTime? newDate = await showDatePicker(
      context: context,
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: mainColor(context),
              onPrimary: Colors.white,
              onSurface: Colors.black,
            ),
            textButtonTheme: TextButtonThemeData(
              style: TextButton.styleFrom(
                primary: Colors.white,
                backgroundColor: mainColor(context),
                textStyle: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          child: child!,
        );
      },
      initialDate: startDate,
      firstDate: DateTime(1900),
      lastDate: DateTime(2100, 12, 31),
    );

    if (newDate == null) return null;

    return newDate;
  }

  Future<TimeOfDay?> pickTime(BuildContext context) async {
    return showTimePicker(
      context: context,
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: mainColor(context),
              surfaceTint: Colors.red,
              onPrimary: Colors.white,
              onSurface: Colors.black,
              onBackground: Colors.grey,
            ),
            textButtonTheme: TextButtonThemeData(
              style: TextButton.styleFrom(
                primary: Colors.white,
                backgroundColor: mainColor(context),
                textStyle: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
          child: child!,
        );
      },
      initialTime: TimeOfDay(
        hour: dateTime.hour,
        minute: dateTime.minute,
      ),
    );
  }
}
