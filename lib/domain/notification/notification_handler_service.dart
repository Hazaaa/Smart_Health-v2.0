import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:smart_health_v2/presentation/screens/bottom_navigation_screen.dart';
import 'package:smart_health_v2/presentation/screens/notification_details_screen.dart';

class NotificationHandlerService {
  static void handleFirebaseNotification(
      BuildContext context, RemoteMessage message) {
    final route = message.data['route'];
    final notificationsId = message.data['notificationId'];

    if (route == 'notifications' && notificationsId != null) {
      Navigator.pushReplacement(
          context,
          MaterialPageRoute(
              builder: (context) =>
                  NotificationDetailsScreen(notificationId: notificationsId)));
    } else {
      Navigator.pushReplacement(
          context,
          MaterialPageRoute(
              builder: (context) => BottomNavigationScreen(
                    selectedIndex: 1,
                  )));
    }
  }

  static void registerDevice(String deviceId) {
    FirebaseFirestore.instance
        .collection('deviceTokens')
        .where('deviceToken', isEqualTo: deviceId)
        .get()
        .then((value) => {
              if (value.docs.isEmpty)
                {
                  /// This means that device isnt registered so we need to register it
                }
            });
  }
}
