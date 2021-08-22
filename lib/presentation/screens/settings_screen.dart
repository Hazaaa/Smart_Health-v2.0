import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:smart_health_v2/constants/constants.dart';
import 'package:smart_health_v2/domain/auth/auth_service.dart';
import 'package:smart_health_v2/presentation/common/screen_title.dart';
import 'package:smart_health_v2/routes/routes_constants.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final authService = Provider.of<AuthService>(context);

    return Scaffold(
      backgroundColor: kBackgroundColor,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              /// TITLE
              ScreenTitle(titleText: "Podešavanja", icon: Icons.settings),
              Divider(color: Colors.grey),

              /// SIGN OUT BUTTON
              Container(
                margin: EdgeInsets.only(top: 5.0, left: 20.0, right: 20.0),
                padding: EdgeInsets.all(15.0),
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(25)),
                child: GestureDetector(
                  onTap: () {
                    authService.signOutUser();
                    Navigator.pushReplacementNamed(context, LoginRoute);
                  },
                  child: Row(
                    children: [
                      Icon(FontAwesomeIcons.signOutAlt),
                      SizedBox(
                        width: 15.0,
                      ),
                      Container(
                        margin: EdgeInsets.only(top: 3.0),
                        child: Text(
                          "Odjavi se",
                          style: TextStyle(fontSize: 20.0),
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
