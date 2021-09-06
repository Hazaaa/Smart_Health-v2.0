import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class Notification {
  String? id;
  String title;
  String body;
  String userEmail;
  Timestamp time;
  String type;
  String status;
  List<String>? drugsNames;

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

    if (newNotification.type == 'interaction_required' &&
        json['eRecept'] != null) {
      List<dynamic> drugs = json['eRecept']! as List<dynamic>;

      newNotification.drugsNames = [...drugs];
    }

    return newNotification;
  }

  Color getNotificationColor() {
    if (this.status == 'seen' && this.type != 'interaction_required') {
      return Colors.white;
    }

    if (this.type == 'interaction_required' && this.status == 'done') {
      return Colors.white;
    }

    switch (this.type) {
      case 'information':
        return Colors.blue.shade100;
      case 'interaction_required':
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
