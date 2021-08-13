import 'package:flutter/material.dart';
import 'package:smart_health_v2/presentation/screens/doctor_screen.dart';
import 'package:smart_health_v2/presentation/screens/login_screen.dart';
import 'package:smart_health_v2/routes/routes_constants.dart';

Route<dynamic> generateRoute(RouteSettings settings) {
  switch (settings.name) {
    case HomeRoute:
      return MaterialPageRoute(builder: (context) => DoctorScreen());
    case LoginRoute:
      return MaterialPageRoute(builder: (context) => LoginScreen());
    default:
      return MaterialPageRoute(builder: (context) => LoginScreen());
  }
}
