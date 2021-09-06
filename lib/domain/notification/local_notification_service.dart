import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

/// Service for displaying local notification based on channel
class LocalNotificationService {
  static final FlutterLocalNotificationsPlugin _notificationsPlugin =
      FlutterLocalNotificationsPlugin();

  static void initialize(BuildContext context) {
    final InitializationSettings initializationSettings =
        InitializationSettings(
            android: AndroidInitializationSettings("@mipmap/ic_launcher"));

    _notificationsPlugin.initialize(initializationSettings,
        onSelectNotification: (String? route) async {
      if (route != null) {
        Navigator.pushNamed(context, route);
      }
    });
  }

  static Future<void> displayNotification(RemoteMessage message) async {
    final id = DateTime.now().millisecondsSinceEpoch ~/ 10000000;
    final NotificationDetails notificatioNDetails = NotificationDetails(
        android: AndroidNotificationDetails("notification_chnl",
            "notification_chnl channel", "this is our channel",
            importance: Importance.max, priority: Priority.high));

    await _notificationsPlugin.show(id, message.notification!.title,
        message.notification!.body, notificatioNDetails,
        payload: message.data['route']);
  }
}
