import 'package:cloud_firestore/cloud_firestore.dart';

class Pharmacy {
  String? id;
  final String name;
  final String address;
  final String workingHours;
  final GeoPoint coords;
  final String phoneNumber;
  final String deviceToken;

  Pharmacy(
      {required this.name,
      required this.address,
      required this.workingHours,
      required this.coords,
      required this.phoneNumber,
      required this.deviceToken});

  Pharmacy.fromJson(QueryDocumentSnapshot json)
      : this(
            name: json['name']! as String,
            address: json['address']! as String,
            workingHours: json['workingHours']! as String,
            coords: json['coords']! as GeoPoint,
            phoneNumber: json['phone']! as String,
            deviceToken: json['deviceToken']! as String);
}
