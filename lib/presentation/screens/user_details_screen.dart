import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart' as urlLauncher;
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:smart_health_v2/constants/constants.dart';
import 'package:smart_health_v2/constants/size_confige.dart';
import 'package:smart_health_v2/domain/auth/auth_service.dart';
import 'package:smart_health_v2/domain/auth/models/user_details.dart';

// ignore: must_be_immutable
class UserDetailsScreen extends StatelessWidget {
  UserDetailsScreen();

  UserDetails? userDetails;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: kBackgroundColor,
        body: Consumer<AuthService>(
          builder: (context, authService, snapshot) {
            userDetails = authService.currentUser!.userDetails;
            return SingleChildScrollView(
              child: Center(
                child: Column(
                  children: [
                    SizedBox(height: 10.0),
                    Container(
                      width: double.infinity,
                      child: Stack(
                        children: [
                          Center(
                            child: CircleAvatar(
                              radius: 50.0,
                              backgroundImage:
                                  AssetImage(userDetails!.imageUrl),
                            ),
                          ),
                          Positioned(
                              bottom: 0,
                              right: SizeConfig.screenWidth / 3,
                              child: Container(
                                child: ElevatedButton(
                                  child:
                                      Icon(FontAwesomeIcons.camera, size: 17.0),
                                  style: ElevatedButton.styleFrom(
                                    primary: Colors.grey,
                                    shape: CircleBorder(),
                                    padding: EdgeInsets.all(5),
                                  ),
                                  onPressed: () {},
                                ),
                              )),
                        ],
                      ),
                    ),
                    SizedBox(height: 20.0),
                    Text(
                      userDetails!.name,
                      style: TextStyle(fontSize: 27.0),
                    ),
                    SizedBox(height: 20.0),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Container(
                          width: 100.0,
                          padding: EdgeInsets.all(15.0),
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(10.0),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.grey.withOpacity(0.5),
                                  spreadRadius: 5,
                                  blurRadius: 7,
                                  offset: Offset(0, 3),
                                ),
                              ]),
                          child: Column(
                            children: [
                              Icon(FontAwesomeIcons.weight),
                              SizedBox(height: 10.0),
                              Text("75 kg"),
                            ],
                          ),
                        ),
                        Container(
                          width: 100.0,
                          padding: EdgeInsets.all(15.0),
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(10.0),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.grey.withOpacity(0.5),
                                  spreadRadius: 5,
                                  blurRadius: 7,
                                  offset: Offset(
                                      0, 3), // changes position of shadow
                                ),
                              ]),
                          child: Column(
                            children: [
                              Icon(FontAwesomeIcons.male),
                              SizedBox(height: 10.0),
                              Text("180 cm"),
                            ],
                          ),
                        ),
                        Container(
                          width: 100.0,
                          padding: EdgeInsets.all(15.0),
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(10.0),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.grey.withOpacity(0.5),
                                  spreadRadius: 5,
                                  blurRadius: 7,
                                  offset: Offset(
                                      0, 3), // changes position of shadow
                                ),
                              ]),
                          child: Column(
                            children: [
                              Icon(
                                FontAwesomeIcons.tint,
                                color: Colors.red,
                              ),
                              SizedBox(height: 10.0),
                              Text(userDetails!.bloodType),
                            ],
                          ),
                        )
                      ],
                    ),
                    SizedBox(height: 20.0),
                    Container(
                      width: SizeConfig.screenWidth,
                      margin: EdgeInsets.only(left: 30.0, right: 30.0),
                      padding: EdgeInsets.all(10.0),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10.0),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.5),
                            spreadRadius: 5,
                            blurRadius: 7,
                            offset: Offset(0, 3), // changes position of shadow
                          )
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Alergije:",
                            style: TextStyle(
                              fontSize: 16.0,
                              fontWeight: FontWeight.bold,
                              decoration: TextDecoration.underline,
                            ),
                          ),
                          Wrap(
                            direction: Axis.horizontal,
                            spacing: 10.0,
                            children: [
                              ..._buildAllergiesChips(userDetails!.allergies)
                            ],
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 20.0),
                    Container(
                      margin: EdgeInsets.only(left: 30.0, right: 30.0),
                      padding: EdgeInsets.all(10.0),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10.0),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.5),
                            spreadRadius: 5,
                            blurRadius: 7,
                            offset: Offset(0, 3), // changes position of shadow
                          )
                        ],
                      ),
                      child: Row(
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Izabrani doktor:",
                                style: TextStyle(
                                  fontSize: 16.0,
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold,
                                  decoration: TextDecoration.underline,
                                ),
                              ),
                              Text("Dr. ${userDetails!.choosenDoctorName}")
                            ],
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 20.0),
                    Container(
                      margin: EdgeInsets.only(left: 30.0, right: 30.0),
                      padding: EdgeInsets.all(10.0),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10.0),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.5),
                            spreadRadius: 5,
                            blurRadius: 7,
                            offset: Offset(0, 3), // changes position of shadow
                          )
                        ],
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Kontakt za hitne slučajeve:",
                                style: TextStyle(
                                  fontSize: 16.0,
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold,
                                  decoration: TextDecoration.underline,
                                ),
                              ),
                              Text(userDetails!.emergencyContactName)
                            ],
                          ),
                          Container(
                            margin: EdgeInsets.only(left: 4.0),
                            width: 55.0,
                            height: 35.0,
                            child: MaterialButton(
                              minWidth: 60.0,
                              color: Colors.green,
                              textColor: Colors.white,
                              child: Icon(Icons.phone),
                              shape: CircleBorder(),
                              onPressed: () {
                                urlLauncher.launch(
                                    "tel:${userDetails!.emergencyContactPhone}");
                              },
                            ),
                          ),
                          Container(
                            width: 55.0,
                            height: 35.0,
                            child: MaterialButton(
                              color: Colors.blue,
                              textColor: Colors.white,
                              child: Icon(Icons.message),
                              shape: CircleBorder(),
                              onPressed: () {
                                urlLauncher.launch(
                                    "sms:${userDetails!.emergencyContactPhone}");
                              },
                            ),
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  List<Widget> _buildAllergiesChips(List<dynamic> allergiesNames) {
    List<Widget> createdWidgets = [];
    Map<String, Icon> allergiesIcons = {
      "Sunce": Icon(
        FontAwesomeIcons.sun,
        size: 18.0,
        color: Colors.yellow,
      ),
      "Penicilin": Icon(
        FontAwesomeIcons.syringe,
        size: 17.0,
        color: Colors.grey,
      ),
      "Polen": Icon(
        FontAwesomeIcons.seedling,
        size: 17.0,
        color: Colors.green,
      )
    };
    Map<String, Color> allergiesColors = {
      "Sunce": Colors.yellow,
      "Penicilin": Colors.grey,
      "Polen": Colors.green
    };

    allergiesNames.forEach((allergieName) {
      Icon allergieIcon =
          allergiesIcons[allergieName] ?? Icon(FontAwesomeIcons.allergies);
      Color allergieColor = allergiesColors[allergieName] ?? Colors.white;

      createdWidgets
          .add(_buildAllergieChip(allergieName, allergieIcon, allergieColor));
    });

    return createdWidgets;
  }

  Widget _buildAllergieChip(String allergieName, Icon icon, Color color) {
    return Chip(
      backgroundColor: color,
      label: Text(allergieName),
      avatar: CircleAvatar(
        backgroundColor: Colors.white,
        child: icon,
      ),
    );
  }
}
