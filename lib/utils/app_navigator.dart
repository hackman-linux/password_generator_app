import 'package:flutter/material.dart';

class AppNavigator {
  static final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

  static void pushNamed(String routeName, {Object? arguments}) {
    navigatorKey.currentState?.pushNamed(routeName, arguments: arguments);
  }

  static void pushReplacementNamed(String routeName, {Object? arguments}) {
    navigatorKey.currentState?.pushReplacementNamed(routeName, arguments: arguments);
  }

  static void pop([Object? result]) {
    navigatorKey.currentState?.pop(result);
  }

  static void popUntil(String routeName) {
    navigatorKey.currentState?.popUntil(ModalRoute.withName(routeName));
  }
}