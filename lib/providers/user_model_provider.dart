// import 'dart:ui';
// import 'package:flutter/foundation.dart';
// import 'package:notice_board/helpers/constants.dart';
// import '../models/user_model.dart';

// class UserModelProvider extends ChangeNotifier {
//   String get name => UserModel.name.toString();

//   String get prn => UserModel.prn.toString();

//   String get year => UserModel.year.toString();

//   String get imageUrl => UserModel.imageUrl.toString();

//   String get branch => UserModel.branch.toString();

//   String get email => UserModel.email.toString();

//   String get adminCategory => UserModel.adminCategory.toString();

//   bool get isAdmin => UserModel.isAdmin;

//   Color get mainColor => isAdmin ? kOrangeColor : kVioletShade;

//   void updateName(newName) {
//     UserModel.name = newName;
//     notifyListeners();
//   }

//   void updateBio(newPrn) {
//     UserModel.prn = newPrn;

//     notifyListeners();
//   }

//   void updateImageUrl(newImageUrl) {
//     UserModel.imageUrl = newImageUrl;
//     notifyListeners();
//   }

// // void updateDob(newDob) {
// //   UserModel.dob = newDob;
// //
// //   notifyListeners();
// // }
// }

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:notice_board/services/user_services.dart';
import '../models/user_model.dart';

class UserModelProvider with ChangeNotifier {
  late UserModel _currentUser;

  UserModel get currentUser => _currentUser;

  void createNewUser(UserModel userModel, bool isAdmin) {
    _currentUser = userModel;

    if (isAdmin) {
      AdminServices().addAdmin(userModel);
    } else {
      StudentServices().addStudent(userModel);
    }

    notifyListeners();
  }

  void setCurrentUser(UserModel userModel) {
    _currentUser = userModel;

    notifyListeners();
  }

  void updateUserProperty(String propertyName, dynamic value) {
    switch (propertyName) {
      case 'name':
        _currentUser.name = value;
        break;
      case 'prn':
        _currentUser.prn = value;
        break;
      case 'email':
        _currentUser.email = value;
        break;
      case 'imageUrl':
        _currentUser.imageUrl = value;
        break;
      case 'year':
        _currentUser.year = value;
        break;
      case 'passOutYear':
        _currentUser.passOutYear = value;
        break;
      case 'category':
        _currentUser.adminCategory = value;
        break;
      case 'branch':
        _currentUser.branch = value;
        break;
      case 'uid':
        _currentUser.uid = value;
        break;
      case 'bookmarkNotices':
        _currentUser.bookmarkNotices = value;
        break;
      case 'isAdmin':
        _currentUser.isAdmin = value;
        break;
      default:
        throw ArgumentError('Invalid property name');
    }

    StudentServices().updateStudentProperty(
        _currentUser.uid.toString(), propertyName, value);

    // Notify listeners of the change
    notifyListeners();
  }
}
