import 'package:fcm_handler/fcm_handler.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';

Future<void> initFirebaseMessagingAndroidHandler() async {
  final token = await FirebaseMessaging.instance.getToken();
  debugPrint("Firebase service token: $token");
  FirebaseMessaging.instance.onTokenRefresh.listen((fcmToken) async {
    onHandleTokenRefreshCallback?.call(fcmToken);
  }).onError((err) {
    debugPrint("Firebase: token onError ${err.toString()}");
  });
  FirebaseMessaging.onMessage.listen((RemoteMessage message) {
    debugPrint("Firebase: message recieved");
    _foregroundMessageHandler(message.notification, message);
  }, onError: (error) {
    debugPrint("Firebase: message onError ${error.toString()}");
  }, onDone: () {
    debugPrint("Firebase: message onDone");
  });
  FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
    onHandleNotificationOpenCallback?.call(message.data);
  });
}

Future<void> _foregroundMessageHandler(
    RemoteNotification? notification, RemoteMessage remoteMessage) async {
  showLocalNotification(remoteMessage);
}
