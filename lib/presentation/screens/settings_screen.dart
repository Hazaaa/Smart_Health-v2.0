import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:smart_health_v2/constants/constants.dart';
import 'package:smart_health_v2/constants/size_confige.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBackgroundColor,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                margin: EdgeInsets.only(top: 10.0),
                child: Text(
                  "Settings",
                  style: TextStyle(fontSize: 25.0, fontWeight: FontWeight.bold),
                ),
              ),
              Divider(color: Colors.grey),
              Container(
                margin: EdgeInsets.only(top: 5.0, left: 20.0, right: 20.0),
                padding: EdgeInsets.all(15.0),
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(25)),
                child: Row(
                  children: [
                    Icon(FontAwesomeIcons.signOutAlt),
                    SizedBox(
                      width: 15.0,
                    ),
                    Container(
                      margin: EdgeInsets.only(top: 3.0),
                      child: Text(
                        "Sign out",
                        style: TextStyle(fontSize: 20.0),
                      ),
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
