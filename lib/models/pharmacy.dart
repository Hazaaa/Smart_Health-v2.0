import 'package:cloud_firestore/cloud_firestore.dart';

class Pharmacy {
  final String name;
  final String address;
  final String workingHours;
  final GeoPoint coords;
  final String phoneNumber;

  Pharmacy(
      {required this.name,
      required this.address,
      required this.workingHours,
      required this.coords,
      required this.phoneNumber});

  Pharmacy.fromJson(QueryDocumentSnapshot json)
      : this(
            name: json['name']! as String,
            address: json['address']! as String,
            workingHours: json['workingHours']! as String,
            coords: json['coords']! as GeoPoint,
            phoneNumber: json['phone']! as String);
}
