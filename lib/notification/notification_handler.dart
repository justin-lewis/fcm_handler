import 'dart:convert';
import 'dart:typed_data';

import 'package:fcm_handler/fcm_handler.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

AndroidNotificationChannel? channel;
FlutterLocalNotificationsPlugin? flutterLocalNotificationsPlugin;
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

FlutterLocalNotificationsPlugin getNotificationPlugin() {
  flutterLocalNotificationsPlugin ??= FlutterLocalNotificationsPlugin();
  return flutterLocalNotificationsPlugin!;
}

AndroidNotificationChannel? getChannel() {
  channel ??= AndroidNotificationChannel(
    channelId,
    channelName,
    description: channelDescription,
    groupId: channelGroupId,
    importance: Importance.high,
    enableLights: true,
    showBadge: true,
    enableVibration: true,
    playSound: true,
    vibrationPattern: createVibration(),
    ledColor: const Color.fromARGB(255, 255, 255, 255),
  );
  return channel!;
}

Future<void> initNotificationForIOS() async {
  flutterLocalNotificationsPlugin = getNotificationPlugin();
  const initializationSettingsIOS = DarwinInitializationSettings();
  const initializationSettings =
      InitializationSettings(iOS: initializationSettingsIOS);
  flutterLocalNotificationsPlugin!.initialize(initializationSettings,
      onDidReceiveNotificationResponse: _onSelectNotification,
      onDidReceiveBackgroundNotificationResponse: _onSelectNotification);
  await FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
    alert: true,
    badge: true,
    sound: true,
  );
}

Future<void> initNotificationForAndroid() async {
  flutterLocalNotificationsPlugin = getNotificationPlugin();
  AndroidNotificationChannelGroup androidNotificationChannelGroup =
      AndroidNotificationChannelGroup(channelGroupId, channelGroupName,
          description: channelGroupDescription);
  await flutterLocalNotificationsPlugin
      ?.resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin>()
      ?.createNotificationChannelGroup(androidNotificationChannelGroup);
  final initializationSettingsAndroid =
      AndroidInitializationSettings(notificationIcon);
  final initializationSettings =
      InitializationSettings(android: initializationSettingsAndroid);
  flutterLocalNotificationsPlugin?.initialize(initializationSettings,
      onDidReceiveNotificationResponse: _onSelectNotification,
      onDidReceiveBackgroundNotificationResponse: _onSelectNotification);
  channel ??= getChannel();
  if (channel != null) {
    await flutterLocalNotificationsPlugin
        ?.resolvePlatformSpecificImplementation<
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
  getNotificationPlugin().show(
      notificationId++,
      remoteMessage.notification?.title ?? '',
      remoteMessage.notification?.body ?? '',
      NotificationDetails(
          android: AndroidNotificationDetails(
        getChannel()!.id,
        getChannel()!.name,
        channelDescription: getChannel()!.description,
        enableLights: true,
        ledColor: getChannel()!.ledColor,
        ledOnMs: 1000,
        ledOffMs: 500,
      )),
      payload: json.encode(remoteMessage.data));
}

void _onSelectNotification(NotificationResponse response) {
  defaultNotificationTapHandler(payload: response.payload);
}

Future defaultNotificationTapHandler(
    {bool isFromTerminate = false, String? payload}) async {
  if (payload == null) return null;
  try {
    final response = jsonDecode(payload) as Map<String, dynamic>;
    onHandleNotificationOpenCallback?.call(response);
    return response;
  } catch (error) {
    return null;
  }
}
