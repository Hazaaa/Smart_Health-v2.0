import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class Category {
  final String name;
  final int numOfDoctors;
  final String iconName;

  Category({
    required this.name,
    required this.numOfDoctors,
    required this.iconName,
  });

  Category.fromJson(QueryDocumentSnapshot json)
      : this(
            name: json['name']! as String,
            numOfDoctors: json['numOfDoctors']! as int,
            iconName: json['icon']! as String);

  IconData getIconData() {
    switch (iconName) {
      case "baby":
        return FontAwesomeIcons.baby;
      case "allergies":
        return FontAwesomeIcons.allergies;
      case "eye":
        return FontAwesomeIcons.eye;
      case "favorite":
        return Icons.favorite;
      default:
        return Icons.error;
    }
  }
}
