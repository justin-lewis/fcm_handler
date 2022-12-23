import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';

enum Routes {
  home,
  booking,
  login,
  registerOneTime,
  register,
  goBack,
  loginPassword,
  resetPassword
}

mixin RoutesConst {
  static const String result = "result";
}
mixin RoutePath {
  static const String defaultRoute = "/home";
  static const String home = "/home";
  static const String booking = "/booking";
  static const String notificationDetail = "/notificationDetail";
  static const String notificationList = "/notificationList";
  static const String login = "/login";
  static const String loginPassword = "/loginPassword";
  static const String resetPassword = "/resetPassword";
  static const String registerOneTime = "/registerOneTime";
  static const String register = "/register";
  static const String goBack = "/goBack";
}

void navigateBack(BuildContext context) {
  return Navigator.pop(context);
}

Future pushPage<T>(BuildContext context, Widget page) async {
  return Navigator.push(
      context, MaterialPageRoute(builder: (BuildContext context) => page));
}

Future pushReplacePage(BuildContext context, Widget page) {
  return Navigator.pushReplacement(
      context, MaterialPageRoute(builder: (BuildContext context) => page));
}

bool isRoute(BuildContext context, String name) {
  bool isFound = false;
  Navigator.of(context).popUntil((route) {
    if (route.settings.name == name) {
      isFound = true;
    }
    return true;
  });
  return isFound;
}

Future pushPageWithName<T>(BuildContext context, String name, Widget page,
    {Map<String, dynamic>? arguments,
    bool isAnimationPush = true,
    bool isAnimationPop = true}) async {
  return Navigator.push(
      context,
      PageRouteBuilder(
        settings: RouteSettings(name: name, arguments: arguments ?? {}),
        pageBuilder: (context, animation1, animation2) => page,
        transitionDuration:
            isAnimationPush ? const Duration(milliseconds: 300) : Duration.zero,
        reverseTransitionDuration:
            isAnimationPop ? const Duration(milliseconds: 300) : Duration.zero,
      ));
}

Future pushReplacePageWithName(BuildContext context, Widget page, String name,
    {Map<String, dynamic>? arguments,
    bool isAnimationPush = true,
    bool isAnimationPop = true}) {
  return Navigator.pushReplacement(
      context,
      PageRouteBuilder(
        settings: RouteSettings(name: name, arguments: arguments ?? {}),
        pageBuilder: (context, animation1, animation2) => page,
        transitionDuration:
            isAnimationPush ? const Duration(milliseconds: 300) : Duration.zero,
        reverseTransitionDuration:
            isAnimationPop ? const Duration(milliseconds: 300) : Duration.zero,
      ));
}

Future pushReplacePageNoAnimation(BuildContext context, Widget page) {
  return Navigator.pushReplacement(
    context,
    PageRouteBuilder(
      pageBuilder: (context, animation1, animation2) => page,
      transitionDuration: Duration.zero,
      reverseTransitionDuration: Duration.zero,
    ),
  );
}

Future pushAndRemoveUtilNoAnimation(
    BuildContext context, String name, Widget page) {
  bool isFound = false;
  return Navigator.pushAndRemoveUntil(
      context,
      PageRouteBuilder(
        pageBuilder: (context, animation1, animation2) => page,
        transitionDuration: Duration.zero,
        reverseTransitionDuration: Duration.zero,
      ), (route) {
    if (route.settings.name == name) {
      isFound = true;
    } else if (isFound) {
      return true;
    }
    if (route.isFirst) return true;
    return false;
  });
}

Future pushReplacePageWithAnimation(
    BuildContext context, String name, Widget page,
    {Map<String, dynamic>? arguments,
    bool isAnimationPush = true,
    bool isAnimationPop = true}) {
  return Navigator.pushReplacement(
    context,
    PageRouteBuilder(
      settings: RouteSettings(name: name, arguments: arguments ?? {}),
      pageBuilder: (context, animation1, animation2) => page,
      transitionDuration:
          isAnimationPush ? const Duration(milliseconds: 300) : Duration.zero,
      reverseTransitionDuration:
          isAnimationPop ? const Duration(milliseconds: 300) : Duration.zero,
    ),
  );
}

Future pushPageWithAnimation(BuildContext context, String name, Widget page,
    {Map<String, dynamic>? arguments,
    bool isAnimationPush = true,
    bool isAnimationPop = true}) {
  return Navigator.push(
    context,
    PageRouteBuilder(
      settings: RouteSettings(name: name, arguments: arguments ?? {}),
      pageBuilder: (context, animation1, animation2) => page,
      transitionDuration:
          isAnimationPush ? const Duration(milliseconds: 300) : Duration.zero,
      reverseTransitionDuration:
          isAnimationPop ? const Duration(milliseconds: 300) : Duration.zero,
    ),
  );
}

dynamic getResult(BuildContext context) {
  final arguments = ModalRoute.of(context)?.settings.arguments;
  if (arguments != null &&
      arguments is Map &&
      arguments.containsKey(RoutesConst.result)) {
    return arguments[RoutesConst.result];
  }
  return null;
}

Future<bool> popMultiPageWithResult(
    BuildContext context, int numPagePop, dynamic result) async {
  int countPage = 0;
  Navigator.of(context).popUntil((route) {
    countPage++;
    if (countPage > numPagePop) {
      if (route.settings.arguments is Map) {
        (route.settings.arguments as Map)[RoutesConst.result] = result;
      }
      return true;
    }
    return false;
  });
  return true;
}

Future<bool> popSinglePage(BuildContext context) async {
  if (Navigator.of(context).canPop()) {
    Navigator.of(context).pop();
    return true;
  }
  return false;
}

Future<bool> popSinglePageResult(BuildContext context, dynamic result) async {
  Navigator.pop(context, result);
  return true;
}

Future<bool> popToRootWithResult(BuildContext context, dynamic result) async {
  Navigator.of(context).popUntil((route) => route.isFirst);
  return true;
}

Future<bool> popSinglePageWithResult(
    BuildContext context, dynamic result) async {
  return popMultiPageWithResult(context, 1, result);
}

Future<bool> popToPreviousRouteName(BuildContext context, String name,
    {dynamic result}) async {
  bool isFound = false;
  Navigator.of(context).popUntil((route) {
    if (route.settings.name == name) {
      isFound = true;
    } else if (isFound) {
      if (route.settings.arguments is Map) {
        (route.settings.arguments as Map)[RoutesConst.result] = result;
      }
      return true;
    }
    if (route.isFirst) return true;
    return false;
  });
  return true;
}

Future<bool> pushMultiplePage(
    BuildContext context, Map<String, Widget> pages) async {
  pages.forEach((key, value) {
    pushPageWithAnimation(context, key, value, isAnimationPush: false);
  });
  return true;
}

Future<bool> pushReplaceMultiplePage(
    BuildContext context, Map<String, Widget> pages) async {
  bool isFirst = true;
  pages.forEach((key, value) {
    if (isFirst) {
      isFirst = false;
      pushReplacePageWithAnimation(context, key, value, isAnimationPush: false);
    }
    pushPageWithAnimation(context, key, value, isAnimationPush: false);
  });
  return true;
}

Future<bool> popToRouteName(BuildContext context, String name,
    {dynamic result}) async {
  Navigator.of(context).popUntil((route) {
    if (route.settings.arguments is Map) {
      (route.settings.arguments as Map)[RoutesConst.result] = result;
    }
    if (route.isFirst) return true;
    return route.settings.name == name;
  });
  return true;
}

void exitApp(BuildContext context) {
  exit(0);
}
