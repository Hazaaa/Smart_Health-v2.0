import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
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
  const NotificationScreen();

  @override
  _NotificationScreenState createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  _NotificationScreenState();

  @override
  Widget build(BuildContext context) {
    List<notification.Notification> notifications = [];
    final db = Provider.of<Database>(context, listen: false);
    final authService = Provider.of<AuthService>(context);

    return Scaffold(
      backgroundColor: kBackgroundColor,
      floatingActionButton: _buildTestFloatingActionButton(),
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
                      notifications.add(notification.Notification.getFromJson(
                          element.id, element.data()));
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
                                    context, index, notifications[index], db);
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

  Widget _buildListItem(BuildContext context, int index,
      notification.Notification notification, Database db) {
    final String heroTag = "notification_${index.toString()}";

    return GestureDetector(
      onTap: () {
        if (notification.status == 'new') {
          db.notificationsCollection
              .updateNotificationStatus(notification.id!, 'seen')
              .then(
            (_) {
              _openNotificationDetailsPage(notification);
            },
          ).catchError((_) {
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                content: Text("Unable to update status of notification")));
          });
        } else {
          _openNotificationDetailsPage(notification);
        }
      },
      child: Card(
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
        elevation: 5,
        color: notification.getNotificationColor(),
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

  void _openNotificationDetailsPage(notification.Notification notification) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => NotificationDetailsScreen(
          notificationId: notification.id!,
        ),
      ),
    );
  }

  Widget _buildTestFloatingActionButton() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        FloatingActionButton(
          child: Icon(FontAwesomeIcons.plus),
          backgroundColor: Colors.red,
          onPressed: () {
            FirebaseFirestore.instance.collection('notifications').add(
              {
                'eRecept': {'Aspirin 500mg': 2, 'Probiotic': 1},
                'status': 'new',
                'time': Timestamp.now(),
                'title': 'Izdat Vam je novi eRecept',
                'body': 'Izdat Vam je novi recept od dr. Gorana:',
                'type': 'recipe',
                'userEmail': "12345678901@something.coms"
              },
            );
          },
        ),
        SizedBox(height: 20.0),
        FloatingActionButton(
          child: Icon(FontAwesomeIcons.plus),
          backgroundColor: Colors.blue,
          onPressed: () {
            FirebaseFirestore.instance.collection('notifications').add(
              {
                'status': 'new',
                'time': Timestamp.now(),
                'title': 'Uspešno zakazan pregled',
                'body':
                    'Vas pregled kod dr.Gorana zakazan je za 10.11.2021 u 15:00!',
                'type': 'information',
                'userEmail': "12345678901@something.coms"
              },
            );
          },
        )
      ],
    );
  }
}
