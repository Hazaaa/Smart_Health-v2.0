import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:smart_health_v2/domain/auth/auth_service.dart';
import 'package:smart_health_v2/domain/auth/models/user_details.dart';
import 'package:smart_health_v2/presentation/custom/circular_progress_indicator.dart';

import '../../constants/size_confige.dart';

class DoctorAppBar extends StatelessWidget {
  const DoctorAppBar({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: getRelativeWidth(0.04)),
      child: Consumer<AuthService>(
        builder: (context, authService, snapshot) {
          return FutureBuilder<DocumentSnapshot>(
              future: authService.userDetails,
              builder: (BuildContext context,
                  AsyncSnapshot<DocumentSnapshot> snapshot) {
                if (snapshot.connectionState == ConnectionState.done) {
                  final userDetails = (UserDetails.fromJson(
                      snapshot.data!.data() as Map<String, dynamic>));

                  authService.user?.userDetails = userDetails;
                  return Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Zdravo, ${userDetails.name.split(' ')[0]}",
                            style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.w800,
                                fontSize: getRelativeWidth(0.09)),
                          ),
                        ],
                      ),
                      Container(
                        height: getRelativeHeight(0.06),
                        decoration: BoxDecoration(
                            boxShadow: [
                              BoxShadow(
                                blurRadius: 3,
                                offset: Offset(0, 4),
                                color: Colors.black54,
                              )
                            ],
                            color: Color(0xffA295FD),
                            borderRadius: BorderRadius.circular(5)),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(5),
                          child: Image.asset(userDetails.imageUrl),
                        ),
                      )
                    ],
                  );
                }

                return UpgradedCircularProgressIndicator();
              });
        },
      ),
    );
  }
}
