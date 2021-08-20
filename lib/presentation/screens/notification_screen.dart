import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:smart_health_v2/constants/constants.dart';
import 'package:smart_health_v2/domain/auth/auth_service.dart';
import 'package:smart_health_v2/domain/data/database.dart';
import 'package:smart_health_v2/presentation/common/error_text.dart';
import 'package:smart_health_v2/presentation/custom/circular_progress_indicator.dart';
import 'package:smart_health_v2/models/notification.dart' as notification;

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
              Container(
                margin: EdgeInsets.only(top: 10.0),
                child: Text(
                  "Obaveštenja",
                  style: TextStyle(fontSize: 25.0, fontWeight: FontWeight.bold),
                ),
              ),
              Divider(color: Colors.grey),

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
                    final docs = snapshot.data!.docs;
                    docs.forEach((element) {
                      notifications.add(
                          notification.Notification.fromJson(element.data()));
                    });
                    return Flexible(
                      fit: FlexFit.loose,
                      child: ListView.builder(
                        physics: NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        itemBuilder: (context, index) {
                          return ListTile(
                            title: Text("Test"),
                          );
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
}
