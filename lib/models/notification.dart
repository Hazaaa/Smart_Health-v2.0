import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

// Notifications types
const recipeNotificationType = 'recipe';
const informationNotificationType = 'information';

// Notifications status
// new, seen, waiting, insufficient, done

class Notification {
  String? id;
  String title;
  String body;
  String userEmail;
  Timestamp time;
  String type;
  String status;
  Map<String, dynamic>? drugsNames;
  String? requestId;
  Map<String, dynamic>? additionalData;

  Notification(
      {required this.title,
      required this.body,
      required this.time,
      required this.userEmail,
      required this.type,
      required this.status});

  Notification.fromJson(Map<String, Object?> json)
      : this(
            title: json['title']! as String,
            body: json['body']! as String,
            userEmail: json['userEmail']! as String,
            time: json['time']! as Timestamp,
            type: json['type']! as String,
            status: json['status']! as String);

  static Notification getFromJson(
      String notificationId, Map<String, Object?> json) {
    Notification newNotification = Notification.fromJson(json);
    newNotification.id = notificationId;

    if (newNotification.type == recipeNotificationType &&
        json['eRecept'] != null) {
      Map<String, dynamic> drugs = json['eRecept']! as Map<String, dynamic>;

      newNotification.drugsNames = drugs;
      newNotification.requestId = json['requestId'] as String?;
      newNotification.additionalData =
          json['additionalData'] as Map<String, dynamic>?;
    }

    return newNotification;
  }

  Color getNotificationColor() {
    if (this.status == 'seen' && this.type != recipeNotificationType) {
      return Colors.white;
    }

    if (this.type == recipeNotificationType &&
        (this.status == 'done' || this.status == 'decline')) {
      return Colors.white;
    }

    switch (this.type) {
      case informationNotificationType:
        return Colors.blue.shade100;
      case recipeNotificationType:
        return Colors.red.shade100;
      default:
        return Colors.white;
    }
  }

  String getFormatedDateTime() {
    DateTime dateTime = this.time.toDate();
    String year = dateTime.year.toString();
    String month = dateTime.month.toString();
    String day = dateTime.day.toString();
    String hour = dateTime.hour.toString();
    String minute = dateTime.minute < 10
        ? '0' + dateTime.minute.toString()
        : dateTime.minute.toString();

    return '$day.$month.$year $hour:$minute';
  }

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

    if (diffInHours < 24) {
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
