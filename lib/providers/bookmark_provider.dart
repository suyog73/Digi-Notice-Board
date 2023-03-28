import 'package:flutter/foundation.dart';
import 'package:notice_board/models/user_model.dart';
import 'package:notice_board/services/user_services.dart';

// class BookmarkProvider extends ChangeNotifier {
//   List get bookmarks => UserModel.bookmarkNotices;

//   bool isBookmark(noticeId) {
//     return bookmarks.contains(noticeId);
//   }

//   void addBookmark(noticeId) {
//     UserModel.bookmarkNotices.add(noticeId);

//     notifyListeners();
//   }

//   void deleteBookmark(noticeId) {
//     UserModel.bookmarkNotices.removeWhere((element) => element == noticeId);

//     notifyListeners();
//   }
// }

class BookmarkProvider with ChangeNotifier {
  UserModel _userModel;

  BookmarkProvider(this._userModel);

  List<dynamic> get bookmarks => _userModel.bookmarkNotices;

  bool isBookmark(String noticeId) {
    return bookmarks.contains(noticeId);
  }

  void addBookmark(String noticeId) {
    bookmarks.add(noticeId);

    // Update the UserModel with the new bookmarks list
    _userModel.bookmarkNotices = bookmarks;
    StudentServices()
        .updateBookmark(_userModel.uid.toString(), _userModel.bookmarkNotices);

    notifyListeners();
  }

  void deleteBookmark(String noticeId) {
    bookmarks.removeWhere((element) => element == noticeId);

    // Update the UserModel with the new bookmarks list
    _userModel.bookmarkNotices = bookmarks;
    StudentServices()
        .updateBookmark(_userModel.uid.toString(), _userModel.bookmarkNotices);

    notifyListeners();
  }
}
