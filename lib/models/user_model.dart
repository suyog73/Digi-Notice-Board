// class UserModel {
//   static String? name;
//   static String? prn;
//   static String? email;
//   static String? imageUrl;
//   static String? year;
//   static String? passOutYear;
//   static String? adminCategory;
//   // static String? password;
//   static String? branch;
//   static String? uid;
//   static List<dynamic> bookmarkNotices = [];
//   // static List<dynamic> seenList = [];
//   // static List<dynamic> acknowledgeList = [];
//   static bool isAdmin = false;
// }

class UserModel {
  String? name;
  String? prn;
  String? email;
  String? imageUrl;
  String? year;
  String? passOutYear;
  String? adminCategory;
  String? branch;
  String? uid;
  List<dynamic> bookmarkNotices = [];
  bool isAdmin = false;

  UserModel({
    required this.name,
    required this.prn,
    required this.email,
    required this.imageUrl,
    required this.year,
    required this.passOutYear,
    required this.adminCategory,
    required this.branch,
    required this.uid,
    required this.bookmarkNotices,
    required this.isAdmin,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      name: json['name'],
      prn: json['prn'],
      email: json['email'],
      imageUrl: json['imageUrl'],
      year: json['year'],
      passOutYear: json['passOutYear'],
      adminCategory: json['adminCategory'],
      branch: json['branch'],
      uid: json['uid'],
      bookmarkNotices: json['bookmarkNotices'] ?? [],
      isAdmin: json['isAdmin'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'prn': prn,
      'email': email,
      'imageUrl': imageUrl,
      'year': year,
      'passOutYear': passOutYear,
      'adminCategory': adminCategory,
      'branch': branch,
      'uid': uid,
      'bookmarkNotices': bookmarkNotices,
      'isAdmin': isAdmin,
    };
  }
}
