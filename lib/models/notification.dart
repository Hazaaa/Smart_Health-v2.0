import 'package:cloud_firestore/cloud_firestore.dart';

class Notification {
  String text;
  String userEmail;
  Timestamp time;

  Notification(
      {required this.text, required this.time, required this.userEmail});

  Notification.fromJson(Map<String, Object?> json)
      : this(
            text: json['text']! as String,
            userEmail: json['userEmail']! as String,
            time: json['time'] as Timestamp);
}
