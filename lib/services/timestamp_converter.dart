import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

class TimestampConverter {
  String getDateFromTimestamp(Timestamp timestamp) {
    final date = timestamp.toDate();
    final month = DateFormat.MMM().format(date);
    final day = DateFormat.d().format(date);
    final year = DateFormat.y().format(date);
    return '$month $day, $year';
  }

  String getTimeFromTimestamp(Timestamp timestamp) {
    DateTime dateTime = timestamp.toDate();
    String hour = dateTime.hour.toString().padLeft(2, '0');
    String minute = dateTime.minute.toString().padLeft(2, '0');
    return '$hour:$minute';
  }
}
