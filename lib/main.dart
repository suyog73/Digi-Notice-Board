// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:notice_board/getData/get_teacher.dart';
import 'package:notice_board/helpers/constants.dart';
import 'package:notice_board/helpers/static_model.dart';
import 'package:notice_board/providers/acknowledgement_provider.dart';
import 'package:notice_board/providers/bookmark_provider.dart';
import 'package:notice_board/providers/notice_model_provider.dart';
import 'package:notice_board/providers/seen_provider.dart';
import 'package:notice_board/providers/user_model_provider.dart';
import 'package:notice_board/services/firebase_dynamic_link.dart';
import 'package:notice_board/services/notificationservice.dart';
import 'package:provider/provider.dart';

Future<void> _messageHandler(RemoteMessage message) async {
  // print('background message ${message.notification!.body}');
}

const AndroidNotificationChannel channel = AndroidNotificationChannel(
  'high_importance_channel', // id
  'High Importance Notifications', // title
  // description: 'This channel is used for important notifications.', // description
  importance: Importance.high,
  playSound: true,
);

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  // print("Handling a background message: ${message.messageId}");
}

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  NotificationService().initNotification();
  await dotenv.load(fileName: ".env");

  DynamicLinkService().initDynamicLink();

  FirebaseMessaging.onBackgroundMessage(_messageHandler);

  FirebaseMessaging messaging = FirebaseMessaging.instance;

  NotificationSettings settings = await messaging.requestPermission(
    alert: true,
    announcement: false,
    badge: true,
    carPlay: false,
    criticalAlert: false,
    provisional: false,
    sound: true,
  );
  print('User granted permission: ${settings.authorizationStatus}');

  //Yash
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  await flutterLocalNotificationsPlugin
      .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin>()
      ?.createNotificationChannel(channel);
  await FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
    alert: true, // Required to display a heads up notification
    badge: true,
    sound: true,
  );

  //Local Notification
  FirebaseMessaging.onMessage.listen((RemoteMessage message) {
    // print('Got a message whilst in the foreground!');
    // print('Message data: ${message.data}');
    //
    // if (message.notification != null) {
    //   print('Message also contained a notification: ${message.notification}');
    // }

    RemoteNotification? notification = message.notification;
    AndroidNotification? android = message.notification?.android;
    if (notification != null && android != null) {
      flutterLocalNotificationsPlugin.show(
        notification.hashCode,
        notification.title,
        notification.body,
        NotificationDetails(
          android: AndroidNotificationDetails(
            channel.id,
            channel.name,
            // description: channel.description,
            color: Colors.blue,
            playSound: true,
            icon: '@mipmap/ic_launcher',
          ),
        ),
      );
    }
  });

  FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
    // print('A new onMessageOpenedApp event was published!');
    RemoteNotification? notification = message.notification;
    AndroidNotification? android = message.notification?.android;
    if (notification != null && android != null) {
      // showDialog(
      //     context: context,
      //     builder: (_) {
      //       return AlertDialog(
      //         title: Text(notification.title),
      //         content: SingleChildScrollView(
      //           child: Column(
      //             crossAxisAlignment: CrossAxisAlignment.start,
      //             children: [Text(notification.body)],
      //           ),
      //         ),
      //       );
      //     });
      // print("Body : " + notification.body!);
    }
  });

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => UserModelProvider()),
        ChangeNotifierProvider(create: (_) => BookmarkProvider(staticUser)),
        ChangeNotifierProvider(create: (_) => NoticeModelProvider()),
        ChangeNotifierProvider(
            create: (_) => SeenProvider(
                currentNotice: staticNotice, currentUser: staticUser)),
        ChangeNotifierProvider(
            create: (_) => AcknowledgementProvider(staticNotice, staticUser)),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  void showNotification(String title, String message) {
    flutterLocalNotificationsPlugin.show(
      0,
      title,
      message,
      NotificationDetails(
        android: AndroidNotificationDetails(
          channel.id,
          channel.name,
          // description: channel.description,
          color: Colors.blue,
          playSound: true,
          icon: '@mipmap/ic_launcher',
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    // showNotification("Hey", "Welcome");

    // print(AppSettings.pushNotification.toString());
    FirebaseMessaging.onMessage.listen((RemoteMessage event) {
      // print(event.notification!.body);
    });
    FirebaseMessaging.onMessageOpenedApp.listen((message) {
      // print('Message clicked!');
    });
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      // DeviceOrientation.portraitDown,
    ]);
    // User? user = FirebaseAuth.instance.currentUser;

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: appName,
      theme: ThemeData(primarySwatch: Colors.purple),
      home: GetTeachers(),
    );
  }
}
