import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:smart_health_v2/constants/constants.dart';
import 'package:smart_health_v2/domain/auth/auth_service.dart';
import 'package:smart_health_v2/domain/data/database.dart';
import 'package:smart_health_v2/models/notification.dart' as notification;
import 'package:smart_health_v2/presentation/common/error_text.dart';
import 'package:smart_health_v2/presentation/common/screen_title.dart';
import 'package:smart_health_v2/presentation/custom/circular_progress_indicator.dart';
import 'package:smart_health_v2/presentation/screens/map_screen.dart';

class NotificationDetailsScreen extends StatefulWidget {
  final String notificationId;
  NotificationDetailsScreen({required this.notificationId});

  @override
  _NotificationDetailsScreenState createState() =>
      _NotificationDetailsScreenState(notificationId: notificationId);
}

class _NotificationDetailsScreenState extends State<NotificationDetailsScreen> {
  final String notificationId;
  _NotificationDetailsScreenState({required this.notificationId});

  Database? db;
  AuthService? authService;
  Map<String, dynamic> drugs = {};

  @override
  Widget build(BuildContext context) {
    db = Provider.of<Database>(context, listen: false);
    authService = Provider.of<AuthService>(context);

    return Scaffold(
      backgroundColor: kBackgroundColor,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              StreamBuilder<DocumentSnapshot>(
                stream:
                    db!.notificationsCollection.getNotification(notificationId),
                builder: (context, AsyncSnapshot<DocumentSnapshot> snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return UpgradedCircularProgressIndicator();
                  } else if (snapshot.connectionState == ConnectionState.done) {
                    return Text("Nemate obaveštenja!");
                  } else if (snapshot.hasError) {
                    return ErrorText(
                        'Došlo je do greške prilikom pribavljanja obaveštenja!');
                  } else {
                    final doc = snapshot.data!.data();
                    final notificationData =
                        notification.Notification.getFromJson(
                            notificationId, doc as Map<String, Object?>);

                    if (notificationData.drugsNames != null) {
                      drugs = notificationData.drugsNames!;
                      return Column(
                        children: [
                          /// TITLE
                          ScreenTitle(
                            titleText: notificationData.title,
                            heroTag: notificationData.title,
                            backArrow: true,
                            backSelectedIndex: 1,
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
                                  child: Text(
                                      notificationData.getFormatedDateTime()),
                                ),
                              ],
                            ),
                          ),
                          Divider(color: Colors.grey),
                          Container(
                            margin: EdgeInsets.only(right: 10.0, left: 15.0),
                            child: Text(
                              notificationData.body,
                              style: TextStyle(fontSize: 18.0),
                            ),
                          ),
                          SizedBox(height: 15.0),
                          _buildRequiredWidgets(notificationData)
                        ],
                      );
                    } else {
                      return Column(
                        children: [
                          /// TITLE
                          ScreenTitle(
                            titleText: notificationData.title,
                            heroTag: notificationData.title,
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
                                  child: Text(
                                      notificationData.getFormatedDateTime()),
                                ),
                              ],
                            ),
                          ),
                          Divider(color: Colors.grey),
                          Container(
                            margin: EdgeInsets.only(right: 10.0, left: 15.0),
                            child: Text(
                              notificationData.body,
                              style: TextStyle(fontSize: 18.0),
                            ),
                          ),
                        ],
                      );
                    }
                  }
                },
              ),
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

  Widget _buildDrugsList(Map<String, dynamic>? drugsNames) {
    return Container(
      margin: EdgeInsets.only(right: 10.0, left: 15.0),
      child: ListView.builder(
        shrinkWrap: true,
        itemBuilder: (context, index) {
          String key = drugsNames!.keys.elementAt(index);
          return Text(
            '- $key: ${drugsNames[key]} kom',
            style: TextStyle(fontSize: 18.0),
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
          SizedBox(height: 15.0),
          Text(
            "Čeka se odgovor apoteke... ",
            style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 20.0),
          UpgradedCircularProgressIndicator()
        ],
      );
    }

    if (_notification.status == 'done') {
      return Column(children: [
        SizedBox(height: 15.0),
        Text(
          "Lekovi su spremni za preuzimanje u odabranoj apoteci!",
          style: TextStyle(fontSize: 15.0, fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 15.0),
        Text(
          "Izdati lekovi:",
          style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
        ),
        _buildDrugsList(_notification.additionalData!['drugsIssued']),
        SizedBox(height: 15.0),
        ElevatedButton.icon(
            onPressed: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => MapScreen(
                            selectedPharmacyId:
                                _notification.additionalData!['pharmacyId'],
                          )));
            },
            icon: Icon(FontAwesomeIcons.directions, size: 13.0),
            label: Text("Prikaži na mapi"))
      ]);
    }

    if (_notification.status == 'insufficient') {
      return Container(
        margin: EdgeInsets.only(left: 15.0, right: 15.0),
        child: Column(
          children: [
            SizedBox(height: 10.0),
            Text(
              "Poruka od apoteke:",
              style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10.0),
            Text(
              "${_notification.additionalData!['message']}",
              style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 15.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                ElevatedButton.icon(
                  onPressed: () {
                    _acceptRequest(_notification);
                  },
                  style: ElevatedButton.styleFrom(
                    primary: Colors.green,
                  ),
                  icon: Icon(
                    FontAwesomeIcons.check,
                    size: 20.0,
                  ),
                  label: Text(
                    "Prihvati",
                    style: TextStyle(fontSize: 18.0),
                  ),
                ),
                ElevatedButton.icon(
                  onPressed: () {
                    _declineRequest(_notification);
                  },
                  style: ElevatedButton.styleFrom(
                    primary: Colors.red,
                  ),
                  icon: Icon(
                    FontAwesomeIcons.times,
                    size: 20.0,
                  ),
                  label: Text(
                    "Odbiji",
                    style: TextStyle(fontSize: 18.0),
                  ),
                ),
              ],
            )
          ],
        ),
      );
    }

    return Column(
      children: [
        Visibility(
          visible: _notification.status == 'declined',
          child: Text(
            "Apoteka je odbila vaš zahtev!\nPokušajte u drugoj apoteci:",
            style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
          ),
        ),
        Visibility(
          visible: _notification.status == 'user_declined',
          child: Text(
            "Odbili ste novi zahtev.\nPokušajte u drugoj apoteci:",
            style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
          ),
        ),
        ElevatedButton.icon(
          onPressed: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => MapScreen(
                          pickingPharmacy: true,
                          requestFunction: _createRequest,
                        )));
          },
          icon: Icon(FontAwesomeIcons.handHoldingMedical),
          label: Text("Pokupi"),
        ),
      ],
    );
  }

  void _createRequest(String pharmacyId, String pharmacyDeviceToken) {
    FirebaseFirestore.instance.collection('requests').add({
      'cardNumber': authService!.user!.email!.split("@")[0],
      'pharmacyId': pharmacyId,
      'pharmacyDeviceToken': pharmacyDeviceToken,
      'userDeviceToken': authService!.deviceToken,
      'drugsRequested': drugs,
      'time': Timestamp.now(),
      'status': 'new',
      'notificationId': notificationId
    }).then((value) {
      db!.notificationsCollection.collectionRef
          .doc(notificationId)
          .update({'status': 'waiting', 'requestId': value.id}).then((value) {
        Navigator.pop(context);
      });
    }).catchError((error) => {print(error)});
  }

  void _acceptRequest(notification.Notification _notification) {
    FirebaseFirestore.instance
        .collection('requests')
        .doc(_notification.requestId)
        .update({'status': 'user_accepted'}).then((value) {
      FirebaseFirestore.instance
          .collection('notifications')
          .doc(_notification.id)
          .update({'status': 'waiting'});
    });
  }

  void _declineRequest(notification.Notification _notification) {
    FirebaseFirestore.instance
        .collection('requests')
        .doc(_notification.requestId)
        .update({'status': 'user_declined'}).then((value) {
      FirebaseFirestore.instance
          .collection('notifications')
          .doc(_notification.id)
          .update({'status': 'user_declined'});
    });
  }
}
