import 'dart:convert';
import 'dart:typed_data';
import 'package:fcm_handler/fcm_handler.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

AndroidNotificationChannel? channel;
late FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;
String channelId = "high_importance_channel";
String channelName = "HighChannel";
String channelDescription = "High Importance Channel";

String channelGroupId = "channelGroupId";
String channelGroupName = "HighChannelGroup";
String channelGroupDescription = "HighChannelGroup";

String notificationIcon = '@mipmap/ic_launcher';
int notificationId = 100;

Int64List createVibration() {
  final vibrationPatter = Int64List(4);
  vibrationPatter[0] = 1000;
  vibrationPatter[1] = 0;
  vibrationPatter[2] = 0;
  vibrationPatter[3] = 0;
  return vibrationPatter;
}

Future<void> initNotificationForIOS() async {
  flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
  const initializationSettingsIOS = DarwinInitializationSettings();
  const initializationSettings =
      InitializationSettings(iOS: initializationSettingsIOS);
  flutterLocalNotificationsPlugin.initialize(initializationSettings,
      onDidReceiveNotificationResponse: _onSelectNotification,
      onDidReceiveBackgroundNotificationResponse: _onSelectNotification);
  await FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
    alert: true,
    badge: true,
    sound: true,
  );
}

Future<void> initNotificationForAndroid() async {
  flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
  AndroidNotificationChannelGroup androidNotificationChannelGroup =
      AndroidNotificationChannelGroup(channelGroupId, channelGroupName,
          description: channelGroupDescription);
  await flutterLocalNotificationsPlugin
      .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin>()
      ?.createNotificationChannelGroup(androidNotificationChannelGroup);
  final initializationSettingsAndroid =
      AndroidInitializationSettings(notificationIcon);
  final initializationSettings =
      InitializationSettings(android: initializationSettingsAndroid);
  flutterLocalNotificationsPlugin.initialize(initializationSettings,
      onDidReceiveNotificationResponse: _onSelectNotification,
      onDidReceiveBackgroundNotificationResponse: _onSelectNotification);
  channel ??= AndroidNotificationChannel(
    channelId,
    channelName,
    description: channelDescription,
    groupId: channelGroupId,
    importance: Importance.high,
    enableLights: true,
    vibrationPattern: createVibration(),
    ledColor: const Color.fromARGB(255, 255, 255, 255),
  );
  if (channel != null) {
    await flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(channel!);
  }
  await FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
    alert: true,
    badge: true,
    sound: true,
  );
}

void showLocalNotification(RemoteMessage remoteMessage) {
  flutterLocalNotificationsPlugin.show(
      notificationId++,
      remoteMessage.notification?.title ?? '',
      remoteMessage.notification?.body ?? '',
      NotificationDetails(
          android: AndroidNotificationDetails(
        channel!.id,
        channel!.name,
        channelDescription: channel!.description,
        enableLights: true,
        ledColor: channel!.ledColor,
        ledOnMs: 1000,
        ledOffMs: 500,
      )),
      payload: json.encode(remoteMessage.data));
}

void _onSelectNotification(NotificationResponse response) {
  onNotificationTap(payload: response.payload);
}

Future onNotificationTap(
    {bool isFromTerminate = false, String? payload}) async {
  if (payload == null) return null;
  try {
    final response = json.decode(payload) as Map<String, dynamic>;
    onHandleNotificationOpenCallback?.call(response);
    return response;
  } catch (error) {
    return null;
  }
}
