library fcm_handler;

export 'platform/platform_handler.dart';
export 'notification/notification_handler.dart';

OnHandleTokenRefreshCallback? onHandleTokenRefreshCallback;
OnHandleNotificationOpenCallback? onHandleNotificationOpenCallback;

typedef OnHandleNotificationOpenCallback = void Function(
    Map<String, dynamic> payloadData);
typedef OnHandleTokenRefreshCallback = Future<dynamic> Function(String token);
