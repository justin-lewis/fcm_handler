library fcm_handler;

import 'package:firebase_messaging/firebase_messaging.dart';

export 'notification/notification_handler.dart';
export 'platform/platform_handler.dart';

BackgroundMessageHandler? onHandleBackgroundMessageCallback;
OnHandleTokenRefreshCallback? onHandleTokenRefreshCallback;
OnHandleNotificationOpenCallback? onHandleNotificationOpenCallback;
OnReceivedForegroundNotificationCallback?
    onReceivedForegroundNotificationCallback;

typedef OnHandleNotificationOpenCallback = bool Function(
    Map<String, dynamic> payloadData);

typedef OnHandleTokenRefreshCallback = Future<dynamic> Function(String token);

typedef OnReceivedForegroundNotificationCallback = Future<bool> Function(
    RemoteMessage remoteMessage);
