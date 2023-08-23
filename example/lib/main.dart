import 'package:fcm_handler/fcm_handler.dart';
import 'package:fcm_handler_example/firebase/firebase_options.dart';
import 'package:fcm_handler_example/screen/detail_screen.dart';
import 'package:fcm_handler_example/screen/home_screen.dart';
import 'package:flutter/material.dart';

import 'navigation.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await setupFirebaseApp(DefaultFirebaseOptions.currentPlatform);
  await setupFirebaseHandler();
  onHandleTokenRefreshCallback = handleRefreshToken;
  onHandleNotificationOpenCallback = openNotification;
  runApp(const MyApp());
}

GlobalKey<NavigatorState> navigationKey = MyApp.navigatorKey;

Future<dynamic> handleRefreshToken(String token) async {}

void openNotification(Map<String, dynamic> data) {
  pushPage(navigationKey.currentContext!,
      DetailScreen(notificationId: int.tryParse(data['notificationId']) ?? 0));
}

class MyApp extends StatelessWidget {
  static GlobalKey appKey = GlobalKey();
  static GlobalKey<NavigatorState> navigatorKey = GlobalKey();

  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        key: appKey,
        navigatorKey: navigatorKey,
        title: 'Flutter Demo',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        onGenerateRoute: (RouteSettings routeSettings) {
          handleFirstTimeOpenApp();
          return MaterialPageRoute(
              settings: const RouteSettings(name: "/home", arguments: {}),
              builder: (BuildContext context) => const HomeScreen());
        });
  }
}
