import 'package:cloud_firestore/cloud_firestore.dart';

class Doctor {
  final String name, speciality, image;
  final int reviews;
  final int reviewScore;

  Doctor(
      {required this.name,
      required this.speciality,
      required this.image,
      required this.reviews,
      required this.reviewScore});

  Doctor.fromJson(QueryDocumentSnapshot json)
      : this(
            name: json['name']! as String,
            speciality: json['speciality']! as String,
            image: json['image']! as String,
            reviews: json['reviews']! as int,
            reviewScore: json['reviewScore']! as int);
}
