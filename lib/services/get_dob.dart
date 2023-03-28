String dob = '';

class DOBApi {
  String getDOB(DateTime? date) {
    if (date == null) {
      return "";
    } else {
      String? day = date.day.toString();
      String? month = date.month.toString();
      String? year = date.year.toString();

      if (month.length == 1 && day.length == 1) {
        day = '0$day';
        month = '0$month';
      }
      if (day.length == 1) {
        day = '0$day';
      }
      if (month.length == 1) {
        month = '0$month';
      }
      dob = '$day/$month/$year';
      return dob;
    }
  }

  int getYear(String dob) {
    print(dob.substring(6, 10));
    return int.parse(dob.substring(6, 10));
  }

  int getMonth(String dob) {
    print(dob.substring(3, 5));

    return int.parse(dob.substring(3, 5));
  }

  int getDay(String dob) {
    print(dob.substring(0, 2));

    return int.parse(dob.substring(0, 2));
  }
}
