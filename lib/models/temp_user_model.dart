class TempUserModel {
  String? name;
  String? prn;
  String? email;
  String? imageUrl;
  String? year;
  String? adminCategory;
  String? password;
  String? branch;
  String? uid;
  List<dynamic> bookmarkNotices = [];
  bool isAdmin = false;

  TempUserModel({
    required this.name,
    required this.prn,
    required this.email,
    required this.imageUrl,
    required this.year,
    required this.adminCategory,
    required this.password,
    required this.branch,
    required this.uid,
    required this.bookmarkNotices,
  });
}
