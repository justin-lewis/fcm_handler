## Push Notification guideline

To test this project, you can use PostMan application to send push

### Send test firebase message by using http:

#### Android
```
curl --location --request POST 'https://fcm.googleapis.com/fcm/send' \
--header 'Authorization: key=<Your server legacy key for used with http>' \
--header 'Content-Type: application/json' \
--data-raw '{
    "to": "<device token>",
    "priority": "high",
    "data": {
        "click_action": "FLUTTER_NOTIFICATION_CLICK",
        "title": "This is title",
        "message": "This is message",
        "notificationId": 48
    },
    "notification": {
        "title": "This is title",
        "message": "This is message"
    }
}
'
```

#### IOS
```
curl --location --request POST 'https://fcm.googleapis.com/fcm/send' \
--header 'Authorization: key=<Your server legacy key for used with http>' \
--header 'Content-Type: application/json' \
--data-raw '{
    "to": "<<Your Firebase device token>>",
    "notification": {
        "title": "This is title",
        "body":"This is message"
    },
    "priority": "high",
    "data": {
        "click_action": "FLUTTER_NOTIFICATION_CLICK",
        "title": "This is title",
        "message": "This is message",
        "notificationId": 48
    },
    "apns": {
        "payload": {
            "aps": {
                "mutable-content": 1,
                "content-available": 1
            }
        }
    }
}
'
```
### Implement


Call `setupFirebaseApp` and `setupFirebaseHandler` in `main`
Example:
```
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await setupFirebaseApp();
  await setupFirebaseHandler();
}
```

Set 2 handler func

-  `onHandleTokenRefreshCallback`: for sending new token to your server
-  `onHandleNotificationOpenCallback`: for handling when user tap on notification for open your app screen

```
onHandleTokenRefreshCallback = handleRefreshToken;
onHandleNotificationOpenCallback = openNotification;
```

```
Future<dynamic> handleRefreshToken(String token) async {}

void openNotification(Map<String, dynamic> data) {
  pushPage(navigationKey.currentContext!, const DetailScreen());
}
```


Call `handleFirstTimeOpenApp` in `onGenerateRoute` of MaterialApp for handle firebase message when app is opened when was killed
Example:
```
onGenerateRoute: (RouteSettings routeSettings) {
          handleFirstTimeOpenApp();
          return MaterialPageRoute(
              settings: const RouteSettings(
                  name: "/home", arguments: {}),
              builder: (BuildContext context) => HomeScreen());
        }
```
