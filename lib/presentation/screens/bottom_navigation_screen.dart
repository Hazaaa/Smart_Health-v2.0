import 'package:flutter/material.dart';
import 'package:smart_health_v2/constants/constants.dart';
import 'package:smart_health_v2/presentation/custom/bottom_navigation_bar.dart';
import 'package:smart_health_v2/presentation/screens/doctor_screen.dart';
import 'package:smart_health_v2/presentation/screens/map_screen.dart';
import 'package:smart_health_v2/presentation/screens/notification_screen.dart';
import 'package:smart_health_v2/presentation/screens/settings_screen.dart';

class BottomNavigationScreen extends StatefulWidget {
  BottomNavigationScreen({Key? key}) : super(key: key);

  @override
  _BottomNavigationScreenState createState() => _BottomNavigationScreenState();
}

class _BottomNavigationScreenState extends State<BottomNavigationScreen> {
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBackgroundColor,
      body: _getCorrectScreen(context),
      bottomNavigationBar: BottomNavigation(
        selectedIndex: _selectedIndex,
        onItemPressed: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
        centerIcon: Icons.place,
        itemIcons: [
          Icons.home,
          Icons.notifications,
          Icons.account_box,
          Icons.settings
        ],
      ),
    );
  }

  Widget _getCorrectScreen(BuildContext context) {
    switch (_selectedIndex) {
      case 0:
        return DoctorScreen();
      case 1:
        return NotificationScreen();
      case 2:
        return MapScreen();
      case 4:
        return SettingsScreen();
      default:
        return DoctorScreen();
    }
  }
}
