import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:smart_health_v2/domain/data/database.dart';
import 'package:smart_health_v2/models/doctor.dart';
import 'package:smart_health_v2/presentation/common/error_text.dart';
import 'package:smart_health_v2/presentation/custom/circular_progress_indicator.dart';

import '../../constants/constants.dart';
import '../../constants/size_confige.dart';

class DoctorsList extends StatefulWidget {
  const DoctorsList({Key? key}) : super(key: key);

  @override
  _DoctorsListState createState() => _DoctorsListState();
}

class _DoctorsListState extends State<DoctorsList> {
  @override
  Widget build(BuildContext context) {
    List<Doctor> doctors = [];
    final db = Provider.of<Database>(context, listen: false);

    return Container(
      height: getRelativeHeight(0.35),
      child: FutureBuilder(
        future: db.doctorsCollection.getData(),
        builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) {
            return ErrorText("Došlo je do greške prilikom učitavanja doktora!");
          }

          if (snapshot.connectionState == ConnectionState.done &&
              snapshot.data != null) {
            final docs = snapshot.data!.docs;
            docs.forEach((QueryDocumentSnapshot element) {
              doctors.add(Doctor.fromJson(element));
            });

            return _buildDoctorListView(context, doctors);
          }

          return Center(child: UpgradedCircularProgressIndicator());
        },
      ),
    );
  }

  Widget _buildDoctorListView(BuildContext context, List<Doctor> doctors) {
    return ListView.builder(
      itemCount: doctors.length,
      scrollDirection: Axis.horizontal,
      padding: EdgeInsets.symmetric(horizontal: getRelativeWidth(0.035)),
      itemBuilder: (context, index) {
        final doctor = doctors[index];
        final color = kCategoriesSecondryColor[
            (kCategoriesSecondryColor.length - index - 1)];
        final circleColor = kCategoriesPrimaryColor[
            (kCategoriesPrimaryColor.length - index - 1)];
        final cardWidth = getRelativeWidth(0.48);
        return Row(
          children: [
            Container(
              width: cardWidth,
              child: Stack(
                children: [
                  Column(
                    children: [
                      Stack(
                        children: [
                          Positioned.fill(
                            child: Align(
                              alignment: Alignment.bottomCenter,
                              child: Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(25),
                                    topRight: Radius.circular(25),
                                  ),
                                  color: color,
                                ),
                                height: getRelativeHeight(0.14),
                                child: Stack(
                                  children: [
                                    Align(
                                      alignment: Alignment.topCenter,
                                      child: Container(
                                        width: getRelativeHeight(0.13),
                                        height: getRelativeHeight(0.13),
                                        decoration: BoxDecoration(
                                          border: Border.all(
                                              width: 15,
                                              color:
                                                  circleColor.withOpacity(0.6)),
                                          shape: BoxShape.circle,
                                        ),
                                      ),
                                    ),
                                    Align(
                                      alignment: Alignment.topLeft,
                                      child: Container(
                                        width: getRelativeHeight(0.11),
                                        height: getRelativeHeight(0.11),
                                        decoration: BoxDecoration(
                                          border: Border.all(
                                              width: 15,
                                              color: circleColor
                                                  .withOpacity(0.25)),
                                          shape: BoxShape.circle,
                                        ),
                                      ),
                                    ),
                                    Align(
                                      alignment: Alignment.topRight,
                                      child: Container(
                                        width: getRelativeHeight(0.11),
                                        height: getRelativeHeight(0.11),
                                        decoration: BoxDecoration(
                                          border: Border.all(
                                              width: 15,
                                              color: circleColor
                                                  .withOpacity(0.17)),
                                          shape: BoxShape.circle,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          Container(
                              width: cardWidth,
                              height: getRelativeHeight(0.20),
                              child: Image.asset(doctor.image)),
                        ],
                      ),
                      Container(
                        height: getRelativeHeight(0.135),
                        width: double.infinity,
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.only(
                                bottomLeft: Radius.circular(25),
                                bottomRight: Radius.circular(25))),
                        child: Padding(
                          padding: EdgeInsets.symmetric(
                              vertical: getRelativeHeight(0.02),
                              horizontal: getRelativeWidth((0.05))),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Dr. ${doctor.name.split(' ')[0]}',
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: kHardTextColor,
                                    fontSize: getRelativeWidth(0.041)),
                              ),
                              SizedBox(height: getRelativeHeight(0.005)),
                              Text(
                                doctor.speciality,
                                style: TextStyle(
                                    color: Colors.black.withOpacity(0.8),
                                    fontSize: getRelativeWidth(0.032)),
                              ),
                              SizedBox(height: getRelativeHeight(0.005)),
                              Row(
                                children: [
                                  RatingBar.builder(
                                    unratedColor: Colors.grey.withOpacity(0.5),
                                    itemSize: getRelativeWidth(0.035),
                                    initialRating:
                                        doctor.reviewScore.toDouble(),
                                    minRating: 0,
                                    allowHalfRating: true,
                                    direction: Axis.horizontal,
                                    itemPadding: EdgeInsets.symmetric(
                                        horizontal: getRelativeWidth(0.005)),
                                    itemCount: 5,
                                    updateOnDrag: false,
                                    itemBuilder: (context, _) => Icon(
                                      Icons.star,
                                      color: Colors.orange,
                                    ),
                                    onRatingUpdate: (value) {},
                                  ),
                                  SizedBox(width: getRelativeWidth(0.01)),
                                  Text(
                                    "(${doctor.reviews} Reviews)",
                                    style: TextStyle(
                                        color: Colors.black.withOpacity(0.8),
                                        fontSize: getRelativeWidth(0.022)),
                                  )
                                ],
                              ),
                            ],
                          ),
                        ),
                      )
                    ],
                  ),
                  Positioned.fill(
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Padding(
                        padding: EdgeInsets.only(top: getRelativeHeight(0.04))
                            .copyWith(left: cardWidth * 0.7),
                        child: Container(
                          decoration: BoxDecoration(boxShadow: [
                            BoxShadow(
                              blurRadius: 10,
                              offset: Offset(0, 3),
                              color: Colors.black26,
                            )
                          ], color: Colors.white, shape: BoxShape.circle),
                          padding: EdgeInsets.all(getRelativeWidth(0.015)),
                          child: Icon(
                            FontAwesomeIcons.facebookMessenger,
                            color: color,
                            size: getRelativeWidth(0.055),
                          ),
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
            SizedBox(width: getRelativeWidth(0.04))
          ],
        );
      },
    );
  }
}
