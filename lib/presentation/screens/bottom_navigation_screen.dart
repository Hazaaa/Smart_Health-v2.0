import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:provider/provider.dart';
import 'package:smart_health_v2/constants/constants.dart';
import 'package:smart_health_v2/constants/size_confige.dart';
import 'package:smart_health_v2/domain/auth/auth_service.dart';
import 'package:smart_health_v2/domain/notification/local_notification_service.dart';
import 'package:smart_health_v2/domain/notification/notification_handler_service.dart';
import 'package:smart_health_v2/presentation/custom/bottom_navigation_bar.dart';
import 'package:smart_health_v2/presentation/screens/doctor_screen.dart';
import 'package:smart_health_v2/presentation/screens/map_screen.dart';
import 'package:smart_health_v2/presentation/screens/notification_screen.dart';
import 'package:smart_health_v2/presentation/screens/settings_screen.dart';
import 'package:smart_health_v2/presentation/screens/user_details_screen.dart';
import 'package:smart_health_v2/routes/routes_constants.dart';

class BottomNavigationScreen extends StatefulWidget {
  final int selectedIndex;

  BottomNavigationScreen({this.selectedIndex = 0});

  @override
  _BottomNavigationScreenState createState() =>
      _BottomNavigationScreenState(selectedIndex);
}

class _BottomNavigationScreenState extends State<BottomNavigationScreen> {
  int selectedIndex;

  _BottomNavigationScreenState(this.selectedIndex);

  @override
  void initState() {
    super.initState();

    /// To be able to send notification to concret user we need to register token from firebase messaging
    FirebaseMessaging.instance.getToken().then((deviceToken) {
      final authService = Provider.of<AuthService>(context, listen: false);

      authService.deviceToken = deviceToken;

      if (authService.user != null) {
        FirebaseFirestore.instance
            .collection('requests')
            .where('cardNumber',
                isEqualTo: authService.user!.email!.split("@")[0])
            .get()
            .then((value) => {
                  value.docs.forEach((element) async {
                    await element.reference
                        .update({'userDeviceToken': deviceToken}).catchError(
                            (error) => print(error));
                  })
                })
            .catchError((error) => print(error));
      }
    });

    /// Gives message from notification on which user tapped and opens app when app is closed
    FirebaseMessaging.instance.getInitialMessage().then((message) {
      SizeConfig.initSize(context);
      auth.User? firebaseUser = auth.FirebaseAuth.instance.currentUser;

      if (firebaseUser == null) {
        Navigator.pushNamed(context, LoginRoute);
      }

      if (message != null) {
        NotificationHandlerService.handleFirebaseNotification(context, message);
      }
    });

    /// When app is opened this will be called
    FirebaseMessaging.onMessage.listen((message) {
      LocalNotificationService.displayNotification(message);
    });

    /// When user tap on notification and app is in background
    FirebaseMessaging.onMessageOpenedApp.listen((message) {
      auth.User? firebaseUser = auth.FirebaseAuth.instance.currentUser;

      if (firebaseUser == null) {
        Navigator.pushNamed(context, LoginRoute);
      }

      NotificationHandlerService.handleFirebaseNotification(context, message);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBackgroundColor,
      body: _getCorrectScreen(context),
      bottomNavigationBar: BottomNavigation(
        selectedIndex: selectedIndex,
        onItemPressed: (index) {
          setState(() {
            selectedIndex = index;
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
    switch (selectedIndex) {
      case 0:
        return DoctorScreen();
      case 1:
        return NotificationScreen();
      case 2:
        return MapScreen();
      case 3:
        return UserDetailsScreen();
      case 4:
        return SettingsScreen();
      default:
        return DoctorScreen();
    }
  }
}
