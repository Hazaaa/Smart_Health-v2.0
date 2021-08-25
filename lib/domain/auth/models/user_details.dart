import 'package:cloud_firestore/cloud_firestore.dart';

class UserDetails {
  final String name;
  final String choosenDoctorName;
  final String bloodType;
  final List<dynamic> allergies;
  final String imageUrl;
  final GeoPoint homeCoords;
  final String emergencyContactName;
  final String emergencyContactPhone;

  UserDetails(
      {required this.name,
      required this.choosenDoctorName,
      required this.bloodType,
      required this.allergies,
      required this.imageUrl,
      required this.homeCoords,
      required this.emergencyContactName,
      required this.emergencyContactPhone});

  UserDetails.fromJson(Map<String, dynamic?> json)
      : this(
          name: json['name']! as String,
          choosenDoctorName: json['doctor']! as String,
          bloodType: json['bloodType']! as String,
          allergies: json['allergies'] as List<dynamic>,
          imageUrl: json['imageUrl']! as String,
          homeCoords: json['homeCord']! as GeoPoint,
          emergencyContactName: json['emergencyContact']! as String,
          emergencyContactPhone: json['emergencyContactNumber']! as String,
        );
}
