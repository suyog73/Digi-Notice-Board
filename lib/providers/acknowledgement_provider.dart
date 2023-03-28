import 'package:flutter/material.dart';
import 'package:notice_board/services/notice_services.dart';

import '../models/notice_model.dart';

// class AcknowledgementProvider extends ChangeNotifier {
//   List get acknowledgeList => NoticeModel.acknowledgeList;

//   bool isAcknowledgedByUser(userId) {
//     return acknowledgeList.contains(userId);
//   }

//   void addAcknowledge(userId) {
//     NoticeModel.acknowledgeList.add(userId);

//     notifyListeners();
//   }
// }

import 'package:flutter/foundation.dart';
import 'package:notice_board/models/user_model.dart';

class AcknowledgementProvider with ChangeNotifier {
  UserModel _currentUser;
  NoticeModel _currentNotice;

  AcknowledgementProvider(this._currentNotice, this._currentUser);

  bool isAcknowledged(String userId) {
    return _currentNotice.acknowledgeList.contains(userId);
  }

  void addAcknowledgement() async {
    _currentNotice.acknowledgeList.add(_currentUser.uid);
    await NoticeServices().updateAcknowledgement(
        _currentNotice.noticeId!, _currentUser.uid.toString());
    notifyListeners();
  }
}
