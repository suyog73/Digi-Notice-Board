import 'package:flutter/foundation.dart';
import 'package:notice_board/models/notice_model.dart';
import 'package:notice_board/services/notice_services.dart';

// class NoticeModel1Provider extends ChangeNotifier {
//   String get title => NoticeModel1.title.toString();
//   String get description => NoticeModel1.description.toString();
//   String get subject => NoticeModel1.subject.toString();
//   String get year => NoticeModel1.year.toString();
//   String get branch => NoticeModel1.branch.toString();
//   String get owner => NoticeModel1.owner.toString();
//   String get noticeType => NoticeModel1.noticeType.toString();
//   String get imageUrl => NoticeModel1.imageUrl.toString();
//   String get pdfUrl => NoticeModel1.pdfUrl.toString();
//   String get noticeId => NoticeModel1.noticeId.toString();
//   String get pdfName => NoticeModel1.pdfName.toString();

//   void updateTitle(newTitle) {
//     NoticeModel1.title = newTitle;
//     notifyListeners();
//   }

//   void updateDescription(newDescription) {
//     NoticeModel1.description = newDescription;
//     notifyListeners();
//   }

//   void updateSubject(newSubject) {
//     NoticeModel1.subject = newSubject;
//     notifyListeners();
//   }

//   void updateYear(newYear) {
//     NoticeModel1.year = newYear;
//     notifyListeners();
//   }

//   void updateBranch(newBranch) {
//     NoticeModel1.branch = newBranch;
//     notifyListeners();
//   }

//   void updateNoticeType(newNoticeType) {
//     NoticeModel1.noticeType = newNoticeType;
//     notifyListeners();
//   }

//   void updateImageUrl(newImageUrl) {
//     NoticeModel1.imageUrl = newImageUrl;
//     notifyListeners();
//   }

//   void updatePdfUrl(newPdfUrl) {
//     NoticeModel1.pdfUrl = newPdfUrl;
//     notifyListeners();
//   }

//   void updatePdfName(newPdfName) {
//     NoticeModel1.pdfName = newPdfName;
//     notifyListeners();
//   }
// }

class NoticeModelProvider with ChangeNotifier {
  late NoticeModel _currentNotice;

  NoticeModel get currentNotice => _currentNotice;

  void setCurrentNotice(NoticeModel noticeModel) async {
    _currentNotice = noticeModel;

    await NoticeServices().addNotice(noticeModel);
    notifyListeners();
  }

  void updateNoticeProperty(String propertyName, dynamic value) {
    switch (propertyName) {
      case 'title':
        _currentNotice.title = value;
        break;
      case 'description':
        _currentNotice.description = value;
        break;
      case 'link':
        _currentNotice.link = value;
        break;
      case 'subject':
        _currentNotice.subject = value;
        break;
      case 'year':
        _currentNotice.year = value;
        break;
      case 'branch':
        _currentNotice.branch = value;
        break;
      case 'owner':
        _currentNotice.ownerUid = value;
        break;
      case 'noticeType':
        _currentNotice.noticeType = value;
        break;
      case 'imageUrl':
        _currentNotice.imageUrl = value;
        break;
      case 'pdfUrl':
        _currentNotice.pdfUrl = value;
        break;
      case 'noticeId':
        _currentNotice.noticeId = value;
        break;
      case 'pdfName':
        _currentNotice.pdfName = value;
        break;
      case 'seenList':
        _currentNotice.seenList = value;
        break;
      case 'acknowledgeList':
        _currentNotice.acknowledgeList = value;
        break;
      case 'tags':
        _currentNotice.tags = value;
        break;
      default:
        throw ArgumentError('Invalid property name');
    }

    // Notify listeners of the change
    notifyListeners();
  }
}
