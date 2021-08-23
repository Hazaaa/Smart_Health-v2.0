import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:smart_health_v2/constants/constants.dart';
import 'package:smart_health_v2/domain/auth/auth_service.dart';
import 'package:smart_health_v2/domain/data/database.dart';
import 'package:smart_health_v2/presentation/common/error_text.dart';
import 'package:smart_health_v2/presentation/common/screen_title.dart';
import 'package:smart_health_v2/presentation/custom/circular_progress_indicator.dart';
import 'package:smart_health_v2/models/notification.dart' as notification;
import 'package:smart_health_v2/presentation/screens/notification_details_screen.dart';

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({Key? key}) : super(key: key);

  @override
  _NotificationScreenState createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  @override
  Widget build(BuildContext context) {
    List<notification.Notification> notifications = [];
    final db = Provider.of<Database>(context, listen: false);
    final authService = Provider.of<AuthService>(context, listen: false);

    return Scaffold(
      backgroundColor: kBackgroundColor,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              /// TITLE
              ScreenTitle(titleText: "Obaveštenja", icon: Icons.notifications),
              Divider(color: Colors.grey),

              /// LIST
              StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
                stream: db.notificationsCollection.getDataStream(
                    authService.firebaseAuthInstance.currentUser!.email!),
                builder: (context,
                    AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>>
                        snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return UpgradedCircularProgressIndicator();
                  } else if (snapshot.connectionState == ConnectionState.done) {
                    return Text("Nemate obaveštenja!");
                  } else if (snapshot.hasError) {
                    return ErrorText(
                        'Došlo je do greške prilikom pribavljanja obaveštenja!');
                  } else {
                    notifications.clear();
                    final docs = snapshot.data!.docs;
                    docs.forEach((element) {
                      notifications.add(
                          notification.Notification.fromJson(element.data()));
                    });
                    return notifications.length == 0
                        ? Text("Nemate obaveštenja!")
                        : Flexible(
                            fit: FlexFit.loose,
                            child: ListView.builder(
                              physics: NeverScrollableScrollPhysics(),
                              shrinkWrap: true,
                              itemBuilder: (context, index) {
                                return _buildListItem(
                                    context, index, notifications[index]);
                              },
                              itemCount: notifications.length,
                            ),
                          );
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildListItem(
      BuildContext context, int index, notification.Notification notification) {
    final String heroTag = "notification_${index.toString()}";
    return GestureDetector(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) =>
                    NotificationDetailsScreen(notification, heroTag)));
      },
      child: Card(
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
        elevation: 5,
        shadowColor: Colors.grey,
        margin: EdgeInsets.all(10.0),
        child: Container(
          padding: EdgeInsets.all(10.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Hero(
                    tag: heroTag,
                    child: Text(notification.title,
                        style: TextStyle(fontSize: 18.0)),
                  ),
                  SizedBox(
                    height: 5.0,
                  ),
                  Text("Pre: ${notification.getTimeOfReceiving()}",
                      style: TextStyle(fontSize: 12.0)),
                ],
              ),
              Icon(Icons.arrow_forward_ios_rounded)
            ],
          ),
        ),
      ),
    );
  }
}
