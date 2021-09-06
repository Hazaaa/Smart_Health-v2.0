import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';

class NotificationHandlerService {
  static void handleFirebaseNotification(
      BuildContext context, RemoteMessage message) {
    final routeFromMessage = message.data['route'];
    Navigator.of(context).pushNamed("/$routeFromMessage");
  }
}
