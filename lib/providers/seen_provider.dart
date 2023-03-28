import 'package:flutter/foundation.dart';
import 'package:notice_board/models/notice_model.dart';

import '../models/user_model.dart';
import '../services/notice_services.dart';

// class SeenProvider extends ChangeNotifier {
//   List get seenList => NoticeModel.seenList;

//   bool isSeenByUser(userId) {
//     return seenList.contains(userId);
//   }

//   void addSeen(userId) {
//     NoticeModel.seenList.add(userId);

//     notifyListeners();
//   }
// }



class SeenProvider with ChangeNotifier {
  UserModel currentUser;
  NoticeModel currentNotice;

  SeenProvider({required this.currentNotice,required this.currentUser});

  bool isSeen(String userId) {
    return currentNotice.acknowledgeList.contains(userId);
  }

  void addSeen() async {  
    currentNotice.acknowledgeList.add(currentUser.uid);
    await NoticeServices().updateSeen(
        currentNotice.noticeId!, currentUser.uid.toString());
    notifyListeners();
  }
}
