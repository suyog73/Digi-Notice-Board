// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:introduction_screen/introduction_screen.dart';
import 'package:notice_board/providers/user_model_provider.dart';
import 'package:provider/provider.dart';

const String appName = "Digital Notice Board";
const String appVersion = "1.1.0";

String dbkSirEmail = "dinesh.kulkarni@walchandsangli.ac.in";
String suyogEmail = "suyog.patil@walchandsangli.ac.in";
String shivaEmail = "shivaprasad.umshette@walchandsangli.ac.in";
String rutujaEmail = "rutuja.khillare@walchandsangli.ac.in";
String saurabhEmail = "saurabh.nakade@walchandsangli.ac.in";
String dnyEmail = "dnyaneshwar.shinde1@walchandsangli.ac.in";
String sumitEmail = "sumit.pawade@walchandsangli.ac.in";
String omkarEmail = "omkar.birajdar@walchandsangli.ac.in";

String suyogLinkedIn = "https://www.linkedin.com/in/suyog-patil7/";
String shivaLinkedIn = "https://www.linkedin.com/in/shivaprasadumshette/";
String rutujaLinkedIn = "https://www.linkedin.com/in/rutuja-khilare-b2198021a/";
String saurabhLinkedIn =
    "https://www.linkedin.com/in/saurabh-nakade-17819a212/";
String dnyLinkedIn = "https://www.linkedin.com/in/dnyaneshwarshinde0611/";
String sumitLinkedIn = "https://www.linkedin.com/in/sumit-pawade-43829a1a3/";
String omkarLinkedIn = "https://www.linkedin.com/in/omkar-birajdar-48296a208/";

String suyogGithub = "https://github.com/suyog73";
String shivaGithub = "https://github.com/Shivaprasadumshette";
String rutujaGithub = "https://github.com/rutuja-369";
String saurabhGithub = "https://github.com/saurabhnakade";
String dnyGithub = "https://github.com/create-dan";
String sumitGithub = "https://github.com/SumitP13";
String omkarGithub = "https://github.com/omkar1422";

String tp =
    "The layer that we live on is the outer one with the rocks. Earth is home to not just humans but millions of other plants and species. The water and air on the earth make it possible for life to sustain. As the earth is the only livable planet, we must protect it at all costs.";

const kPrimaryColor = Color(0xff010440);
const Color kBlueShadeColor = Color(0xff0f090a);
const kVioletShade = Color(0xff9085E8);
const Color kGreenShadeColor = Color(0xff05C764);
const Color kLightBlueShadeColor = Color(0xff60EEFB);
const kOrangeColor = Color(0xffFFB74D);
const kBackGroundColor = Color(0xffffffff);
const kOrangeShade2 = Color(0xffFFB74D);
const studentNotice = Color(0xff8479E1); // opacity 0.5
const kHeroTag1 = "profile";

var kTextFormFieldAuthDec = InputDecoration(
  contentPadding: EdgeInsets.only(top: 18, bottom: 18),
  hintStyle: TextStyle(color: Colors.grey.shade700),
  border: InputBorder.none,
  focusedBorder: InputBorder.none,
  enabledBorder: InputBorder.none,
  errorBorder: InputBorder.none,
  disabledBorder: InputBorder.none,
  errorStyle: TextStyle(color: Colors.redAccent),
);

Color mainColor(BuildContext context) {
  bool isAdmin = Provider.of<UserModelProvider>(context).currentUser.isAdmin;
  return isAdmin ? kOrangeColor : kVioletShade;
}

Color mainColor2(BuildContext context) {
  bool isAdmin = Provider.of<UserModelProvider>(context).currentUser.isAdmin;
  return !isAdmin ? kOrangeColor : kVioletShade;
}

Color textColor(BuildContext context) {
  bool isAdmin = Provider.of<UserModelProvider>(context).currentUser.isAdmin;
  return !isAdmin ? Colors.black : Colors.white;
}

// Color mainColor = UserModel.isAdmin ? kOrangeColor : kVioletShade;
// Color mainColor2 = !UserModel.isAdmin ? kOrangeColor : kVioletShade;

// Color textColor = UserModel.isAdmin ? Colors.black : Colors.white;

// var kInputDecoration = InputDecoration(
//   enabledBorder: UnderlineInputBorder(
//     borderSide: BorderSide(color: mainColor),
//   ),
//   focusedBorder: UnderlineInputBorder(
//     borderSide: BorderSide(color: mainColor),
//   ),
//   border: UnderlineInputBorder(
//     borderSide: BorderSide(color: mainColor),
//   ),
// );

PageDecoration kGetPageDecoration() => PageDecoration(
      imageFlex: 2,
      boxDecoration: BoxDecoration(color: Colors.white70),
      titleTextStyle:
          const TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
      bodyTextStyle: const TextStyle(fontSize: 20),
      bodyPadding: const EdgeInsets.all(16).copyWith(bottom: 0),
    );

DotsDecorator kGetDotDecoration() => DotsDecorator(
      color: Colors.white38,
      //activeColor: Colors.orange,
      size: const Size(10, 10),
      activeSize: const Size(22, 10),
      activeColor: Colors.white,
      activeShape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(24),
      ),
    );

final colorList = [
  // Colors.red,
  // Colors.redAccent,
  // Colors.orange,
  // Colors.orangeAccent,
  // Colors.yellow,
  // Color(0xff85F4FF),
  // Color(0xffFF5C8D),
  // Colors.purple,
  // Colors.purpleAccent,
  // Colors.green,
  // Colors.greenAccent,
  // Colors.pink,
  // Colors.pinkAccent,
  // Colors.black,
  // Colors.white,
  // Colors.grey,
  Colors.yellowAccent,
];

DateTime current = DateTime.now();

final academicYears = [
  if (current.month <= 6) current.year.toString(),
  (current.year + 1).toString(),
  (current.year + 2).toString(),
  (current.year + 3).toString(),
  if (current.month > 6) (current.year + 4).toString(),
];

final branches = [
  "Computer Science",
  "Information Technology",
  "Electronics",
  "Electrical",
  "Mechanical",
  "Civil",
];
final shortBranch = ["CSE", "IT", "ENTC", "ELE", "MECH", "CIVIL"];

final todoTags = [
  "Important & Urgent",
  "Urgent",
  "Important",
  "Neither important nor urgent",
];

Map<String, Color> tagColor = {
  // "important":
  todoTags[0]: Colors.red,
  todoTags[1]: Colors.orangeAccent,
  todoTags[2]: kGreenShadeColor,
  todoTags[3]: Colors.grey,
};

final clubs = ["ACSES", "SAIT", "ELESA", "EESA", "MESA", "CESA", "WLUG"];
final category = [
  "Dean",
  "Principal",
  "H.O.D.",
  "Class Teacher",
  "Course Teacher",
  "Class Representative",
  "Other Staff",
];

final noticeType = ["General", "Holiday", "Exam", "Lecture", "Assignment"];
final shortSubjects = ["CA", "CN", "TOC", "SE", "JAVA", "ANDROID"];
final subjects = [
  "Computer Architecture",
  "Computer Network",
  "Theory Of Computation",
  "Software Engineering",
  "Java Language",
  "ANDROID Development"
];
final year = ["First Year", "Second Year", "Third Year", "Final Year"];

String adminUserManual = """
1. Install the WCE-Notice Board application on your phone.
2. If you have admin access then create an account as an Admin.
3. After filling correct details you will get an email verification link. (Check spam folders also).
4. After the email verification, you can create your profile. 
5. After creating an account, you can post any notice. To send a notice go to the second tab and select create a new notice.
6. Fill up all details correctly. You can upload images as well as pdf also.
7. After uploading the notice you can see all your notices in the 1st tab.
8. Inside a notice, you can see the list of students who have seen and acknowledged the notice.
9. Also, the owner of the notice can edit and delete the notice permanently.
10. You can edit your name and can change the profile photo in settings.
""";

String studentUserManual = """
1. Install the WCE-Notice Board application on your phone.
2. Create an account as a student using wce-email id.
3. After filling correct details you will get an email verification link. (Check spam folders also).
4. After the email verification, you can create your profile. 
5. After creating an account, you can see all, branch-wise, academic year-wise, and different category-wise notices. 
6. Students can bookmark the notice.
7. Students will get notifications only for their academic year and branch.
8. Students can acknowledge the notice after reading the whole notice.
9. Students can edit their names and can change their profile photos in settings.
""";
