import 'package:flutter/material.dart';
import 'package:smart_health_v2/presentation/screens/bottom_navigation_screen.dart';
import 'package:smart_health_v2/presentation/screens/login_screen.dart';
import 'package:smart_health_v2/presentation/screens/map_screen.dart';
import 'package:smart_health_v2/presentation/screens/notification_screen.dart';
import 'package:smart_health_v2/presentation/screens/user_details_screen.dart';
import 'package:smart_health_v2/routes/routes_constants.dart';

Route<dynamic> generateRoute(RouteSettings settings) {
  switch (settings.name) {
    case HomeRoute:
      return MaterialPageRoute(builder: (context) => BottomNavigationScreen());
    case LoginRoute:
      return MaterialPageRoute(builder: (context) => LoginScreen());
    case NotificationsRoute:
      return MaterialPageRoute(builder: (context) => NotificationScreen());
    case MapRoute:
      return MaterialPageRoute(builder: (context) => MapScreen());
    case UserDetailsRoute:
      return MaterialPageRoute(builder: (context) => UserDetailsScreen());
    default:
      return MaterialPageRoute(builder: (context) => LoginScreen());
  }
}
