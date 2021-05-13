import 'package:line_icons/line_icons.dart';
import 'package:smart_health_v2/model/category.dart';
import 'package:flutter/material.dart';
import 'package:smart_health_v2/model/doctor.dart';

class Data {
  static final categoriesList = [
    Category(
      title: "Pedijatrija",
      doctorsNumber: 8,
      icon: LineIcons.child,
    ),
    Category(
      title: "Dermatologija",
      doctorsNumber: 7,
      icon: Icons.line_style,
    ),
    Category(
      title: "Oftamologija",
      doctorsNumber: 10,
      icon: LineIcons.eye,
    ),
    Category(
      title: "Kardiologija",
      doctorsNumber: 15,
      icon: Icons.favorite,
    ),
  ];

  static final doctorsList = [
    Doctor(
        name: "Dr. Nemanja",
        speciality: "Pedijatar",
        image: "assets/images/doctor_1.png",
        reviews: 80,
        reviewScore: 4),
    Doctor(
        name: "Dr. Gordana",
        speciality: "Dermatologija",
        image: "assets/images/doctor_2.png",
        reviews: 67,
        reviewScore: 5),
    Doctor(
        name: "Dr. Goran",
        speciality: "Oftamolog",
        image: "assets/images/doctor_3.png",
        reviews: 19,
        reviewScore: 3),
   
  ];
}
