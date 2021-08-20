import 'package:flutter/material.dart';
import 'package:smart_health_v2/presentation/screens/bottom_navigation_screen.dart';
import 'package:smart_health_v2/presentation/screens/login_screen.dart';
import 'package:smart_health_v2/presentation/screens/notification_screen.dart';
import 'package:smart_health_v2/routes/routes_constants.dart';

Route<dynamic> generateRoute(RouteSettings settings) {
  switch (settings.name) {
    case HomeRoute:
      return MaterialPageRoute(builder: (context) => BottomNavigationScreen());
    case LoginRoute:
      return MaterialPageRoute(builder: (context) => LoginScreen());
    case NotificationsRoute:
      return MaterialPageRoute(builder: (context) => NotificationScreen());
    default:
      return MaterialPageRoute(builder: (context) => LoginScreen());
  }
}
