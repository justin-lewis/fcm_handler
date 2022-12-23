import 'dart:convert';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:fcm_handler/notification/notification_handler.dart';

Future<void> initFirebaseMessagingIOSHandler() async {
  debugPrint(
      "Firebase DB firebaseToken: ${await FirebaseMessaging.instance.getToken()}");
  debugPrint(
      "Firebase service APNS token: ${await FirebaseMessaging.instance.getAPNSToken()}");
  FirebaseMessaging.instance.onTokenRefresh.listen((fcmToken) async {
    //updateFcmToken(fcmToken);
  }).onError((err) {
    debugPrint("Firebase: firebaseToken onError ${err.toString()}");
  });
  FirebaseMessaging.onMessage.listen((RemoteMessage message) async {
    debugPrint("Firebase: message recieved");
  }, onError: (error) {
    debugPrint("Firebase: message onError ${error.toString()}");
  }, onDone: () {
    debugPrint("Firebase: message onDone");
  });
  FirebaseMessaging.onMessageOpenedApp.listen((message) {
    onNotificationTap(payload: json.encode(message.data));
  });
}
