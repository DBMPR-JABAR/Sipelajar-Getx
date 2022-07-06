import 'dart:async';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:sipelajar/app/services/api/authProvider.dart';

class FCM {
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;

  final dataCrtl = StreamController<String>.broadcast();
  final titleCtrl = StreamController<String>.broadcast();
  final bodyCtrl = StreamController<String>.broadcast();

  setNotifications() async {
    NotificationSettings settings = await _firebaseMessaging.requestPermission(
      alert: true,
      sound: true,
      badge: true,
    );

    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      print('authorized notif');

      foregroundNotification();
      backgroundNotification();
      terminateNotification();
    } else {
      print('not authorized');
    }

    _firebaseMessaging.onTokenRefresh.listen((token) async {
      await AuthProvider.updateFcm(token);
    });
  }

  foregroundNotification() {
    FirebaseMessaging.onMessage.listen((event) {
      print('foreground: $event');
      print('background: ${event.notification!.android!.priority}');
      print(event.data);
    });
  }

  backgroundNotification() {
    FirebaseMessaging.onMessageOpenedApp.listen((event) {
      print('background: ${event.notification!.android!.priority}');
      print(event.data);
    });
  }

  terminateNotification() async {
    RemoteMessage? initialMessage =
        await FirebaseMessaging.instance.getInitialMessage();
    print('terminate: $initialMessage');
    print(initialMessage?.data);
  }
}
