import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:smart_health_v2/constants/constants.dart';
import 'package:smart_health_v2/models/notification.dart' as notification;
import 'package:smart_health_v2/presentation/common/screen_title.dart';

class NotificationDetailsScreen extends StatefulWidget {
  final notification.Notification _notification;
  NotificationDetailsScreen(this._notification);

  @override
  _NotificationDetailsScreenState createState() =>
      _NotificationDetailsScreenState(_notification);
}

class _NotificationDetailsScreenState extends State<NotificationDetailsScreen> {
  final notification.Notification _notification;
  _NotificationDetailsScreenState(this._notification);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBackgroundColor,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              /// TITLE
              ScreenTitle(
                titleText: _notification.title,
                heroTag: _notification.title,
                backArrow: true,
              ),
              Divider(color: Colors.grey),
              Container(
                margin: EdgeInsets.only(left: 15.0),
                child: Row(
                  children: [
                    Icon(
                      FontAwesomeIcons.clock,
                      size: 18.0,
                    ),
                    SizedBox(
                      width: 10.0,
                    ),
                    Container(
                      margin: EdgeInsets.only(top: 3.0),
                      child: Text(_notification.getFormatedDateTime()),
                    ),
                  ],
                ),
              ),
              Divider(color: Colors.grey),
              Container(
                margin: EdgeInsets.only(right: 10.0, left: 15.0),
                child: Text(
                  _notification.body,
                  style: TextStyle(fontSize: 18.0),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
