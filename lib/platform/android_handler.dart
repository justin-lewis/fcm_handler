import 'dart:convert';

import 'package:fcm_handler/fcm_handler.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';

Future<void> initFirebaseMessagingAndroidHandler() async {
  if (kDebugMode) {
    final token = await getFirebaseToken();
    debugPrint("Firebase service token: $token");
  }
  FirebaseMessaging.instance.onTokenRefresh.listen((fcmToken) async {
    debugPrint("Firebase: token");
    await onHandleTokenRefreshCallback?.call(fcmToken);
  }).onError((err) {
    debugPrint("Firebase: token onError ${err.toString()}");
  });
  FirebaseMessaging.onMessage.listen((RemoteMessage message) async {
    debugPrint("Firebase: message recieved");
    bool handled = false;
    if (onReceivedForegroundNotificationCallback != null) {
      handled = await onReceivedForegroundNotificationCallback!.call(message);
    }
    if (!handled) defaultForegroundMessageHandler(message);
  }, onError: (error) {
    debugPrint("Firebase: message onError ${error.toString()}");
  }, onDone: () {
    debugPrint("Firebase: message onDone");
  });
  FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
    debugPrint("Firebase: tap message open app");
    bool handled = false;
    if (onHandleNotificationOpenCallback != null) {
      handled = onHandleNotificationOpenCallback!.call(message.data);
    }
    if (!handled) {
      defaultNotificationTapHandler(payload: json.encode(message.data));
    }
  });
  FirebaseMessaging.onBackgroundMessage(
      onHandleBackgroundMessageCallback ?? defaultForegroundMessageHandler);
}
