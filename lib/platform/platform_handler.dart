import 'dart:convert';
import 'dart:io';

import 'package:fcm_handler/notification/notification_handler.dart';
import 'package:fcm_handler/platform/android_handler.dart';
import 'package:fcm_handler/platform/ios_handler.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

bool firstOpenApp = true;

Future setupFirebaseApp(FirebaseOptions options) async {
  if (Firebase.apps.isEmpty) {
    await Firebase.initializeApp(
      options: options,
    );
  }
}

Future setupFirebaseHandler() async {
  if (Platform.isIOS) {
    await initNotificationForIOS();
    final isPermissionGranted = await flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            IOSFlutterLocalNotificationsPlugin>()
        ?.requestPermissions(
          alert: true,
          badge: true,
          sound: true,
        );
    if (isPermissionGranted == true) {
      await initFirebaseMessagingIOSHandler();
    }
  } else if (Platform.isAndroid) {
    await initNotificationForAndroid();
    final isPermissionGranted = await flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.requestNotificationsPermission();
    if (isPermissionGranted == true) {
      await initFirebaseMessagingAndroidHandler();
    }
  }
}

void handleFirstTimeOpenApp() {
  if (firstOpenApp) {
    firstOpenApp = false;
    FirebaseMessaging.instance.getInitialMessage().then((value) {
      if (value != null) {
        onNotificationTap(
            isFromTerminate: true, payload: json.encode(value.data));
      }
    });
  }
}
