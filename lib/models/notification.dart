import 'package:cloud_firestore/cloud_firestore.dart';

class Notification {
  String title;
  String body;
  String userEmail;
  Timestamp time;

  Notification(
      {required this.title,
      required this.body,
      required this.time,
      required this.userEmail});

  Notification.fromJson(Map<String, Object?> json)
      : this(
            title: json['title']! as String,
            body: json['body']! as String,
            userEmail: json['userEmail']! as String,
            time: json['time'] as Timestamp);

  /// Returns time of recieving difference to DateTime.now in human readable string
  String getTimeOfReceiving() {
    DateTime dateTime = this.time.toDate();
    DateTime now = DateTime.now();

    final difference = now.difference(dateTime);
    final diffInSec = difference.inSeconds;

    if (diffInSec < 60) {
      return '${diffInSec.toString()} sekunde';
    }

    final diffInMin = difference.inMinutes;

    if (diffInMin < 60) {
      return '${diffInMin.toString()} minuta';
    }

    final diffInHours = difference.inHours;

    if (diffInHours < 60) {
      return '${diffInHours.toString()} sati';
    }

    final diffInDays = difference.inDays;

    if (diffInDays < 7) {
      return '${diffInDays.toString()} dana';
    } else {
      return '${diffInDays.toString()} nedelja';
    }
  }
}
