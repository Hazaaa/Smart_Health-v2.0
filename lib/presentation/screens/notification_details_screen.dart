import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:smart_health_v2/constants/constants.dart';
import 'package:smart_health_v2/models/notification.dart' as notification;
import 'package:smart_health_v2/presentation/common/screen_title.dart';
import 'package:smart_health_v2/presentation/custom/circular_progress_indicator.dart';

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
              SizedBox(height: 15.0),
              Visibility(
                  visible: _notification.drugsNames != null,
                  child: _buildRequiredWidgets(_notification))
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildRequiredWidgets(notification.Notification _notification) {
    return Column(
      children: [
        _buildDrugsList(_notification.drugsNames),
        Divider(),
        _buildControls(_notification)
      ],
    );
  }

  Widget _buildDrugsList(List<dynamic>? drugsNames) {
    return Container(
      margin: EdgeInsets.only(right: 10.0, left: 15.0),
      child: ListView.builder(
        shrinkWrap: true,
        itemBuilder: (context, index) {
          return Text(
            '- ${drugsNames![index]}',
            style: TextStyle(fontSize: 15.0),
          );
        },
        itemCount: drugsNames!.length,
      ),
    );
  }

  Widget _buildControls(notification.Notification _notification) {
    if (_notification.status == 'waiting') {
      return Column(
        children: [
          Text("Čeka se odgovor apoteke... "),
          SizedBox(height: 20.0),
          UpgradedCircularProgressIndicator()
        ],
      );
    }

    if (_notification.status == 'done') {
      return Column(children: [
        Text(
          "Lekovi su spremni za preuzimanje u odabranoj apoteci!",
          style: TextStyle(fontSize: 16.0),
        ),
        ElevatedButton.icon(
            onPressed: () {},
            icon: Icon(FontAwesomeIcons.directions, size: 13.0),
            label: Text("Prikaži na mapi"))
      ]);
    }

    return ElevatedButton.icon(
        onPressed: () {},
        icon: Icon(FontAwesomeIcons.handHoldingMedical),
        label: Text("Pokupi"));
  }
}
