import 'package:flutter/material.dart';
import 'package:smart_health_v2/constants/constants.dart';
import 'package:smart_health_v2/models/notification.dart' as notification;
import 'package:smart_health_v2/presentation/common/screen_title.dart';

class NotificationDetailsScreen extends StatefulWidget {
  final notification.Notification _notification;
  final String _heroTag;
  NotificationDetailsScreen(this._notification, this._heroTag);

  @override
  _NotificationDetailsScreenState createState() =>
      _NotificationDetailsScreenState(_notification, _heroTag);
}

class _NotificationDetailsScreenState extends State<NotificationDetailsScreen> {
  final notification.Notification _notification;
  final String _heroTag;
  _NotificationDetailsScreenState(this._notification, this._heroTag);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBackgroundColor,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              /// TITLE
              ScreenTitle(
                titleText: _notification.title,
                heroTag: _notification.title,
                backArrow: true,
              ),
              Divider(color: Colors.grey),
            ],
          ),
        ),
      ),
    );
  }
}
