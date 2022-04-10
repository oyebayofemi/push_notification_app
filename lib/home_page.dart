import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:overlay_support/overlay_support.dart';
import 'package:push_notification_app/badge/notification_badge.dart';
import 'package:push_notification_app/model/push_notification_model.dart';

class MyHomePage extends StatefulWidget {
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  late final FirebaseMessaging _messaging;
  late int _totalNotificationCounter;

  PushNotificationModel? _notificationInfo;

  void registerNotification() async {
    await Firebase.initializeApp();
    _messaging = FirebaseMessaging.instance;

    NotificationSettings settings = await _messaging.requestPermission(
      alert: true,
      sound: true,
      badge: true,
      provisional: false,
    );

    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      print('User granted the permission');

      FirebaseMessaging.onMessage.listen((RemoteMessage message) {
        PushNotificationModel notification = PushNotificationModel(
            body: message.notification!.body,
            title: message.notification!.title,
            dataBody: message.data['body'],
            dataTitle: message.data['title']);

        setState(() {
          _totalNotificationCounter++;
          _notificationInfo = notification;
        });

        if (notification != null) {
          showSimpleNotification(Text(_notificationInfo!.title!),
              leading: NotificationBadge(
                  notificationValue: _totalNotificationCounter),
              subtitle: Text(_notificationInfo!.body!),
              duration: Duration(seconds: 2),
              background: Colors.blue);
        }
      });
    }
  }

  @override
  void initState() {
    registerNotification();
    super.initState();
    _totalNotificationCounter = 0;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Push Notification'),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Push Notification',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 30),
              ),
              SizedBox(
                height: 20,
              ),
              NotificationBadge(notificationValue: _totalNotificationCounter),
              _notificationInfo != null
                  ? Column(
                      children: [
                        Text(
                            'TITLE: ${_notificationInfo!.title ?? _notificationInfo!.dataTitle}'),
                        SizedBox(
                          height: 9,
                        ),
                        Text(
                            'TITLE: ${_notificationInfo!.dataBody ?? _notificationInfo!.body}')
                      ],
                    )
                  : Container(),
            ],
          ),
        ));
  }
}
