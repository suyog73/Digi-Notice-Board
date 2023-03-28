// ignore_for_file: prefer_const_constructors

import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:flutter_share/flutter_share.dart';

class DynamicLinkService {
  Future<String> createDynamicLink(String noticeId) async {
    print("noticeId");
    print(noticeId);
    String url = "https://com.example.notice_board?noticeId=$noticeId";

    final DynamicLinkParameters parameters = DynamicLinkParameters(
      uriPrefix: 'https://wcenotice.page.link',
      link: Uri.parse(url),
      androidParameters: AndroidParameters(
        packageName: 'com.example.notice_board',
        minimumVersion: 0,
      ),
    );

    final dynamicLink =
        await FirebaseDynamicLinks.instance.buildShortLink(parameters);

    // var dynamicUrl = parameters.link;
    // final Uri shortUrl = shortDynamicLink.shortUrl;
    return dynamicLink.shortUrl.toString();
  }

  void initDynamicLink() async {
    final instanceLink = await FirebaseDynamicLinks.instance.getInitialLink();

    if (instanceLink != null) {
      final Uri noticeIdLink = instanceLink.link;

      // FlutterShare.share(
      //     title: "Link ${noticeIdLink.queryParameters['noticeId']}");
    }
  }
}
