# Firebase messaging handler

A Flutter package that wrap logic for handling logic that show notification and process payload data when user tap on it. 

## Features

- Show notification when received firebase message
- Configurable how application handle notification tap

## Getting started

```
flutter pub add fcm_handler
```

Or

```
dependencies:
  fcm_handler: ^0.0.1
```

## Usage

Set channel information for android and call `setupFirebaseApp` and `setupFirebaseHandler` in `main`
Example:
```
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  channelId = "high_importance_channel";
  channelName = "HighChannel";
  channelDescription = "High Importance Channel";

  channelGroupId = "channelGroupId";
  channelGroupName = "HighChannelGroup";
  channelGroupDescription = "HighChannelGroup";
  
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


## Contributor

- [Justin Lewis](https://github.com/justin-lewis) (Maintainer)
- [dung95bk](https://github.com/dung95bk) (Maintainer)

## License
[MIT](LICENSE)