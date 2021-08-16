import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:smart_health_v2/domain/data/categories_collection.dart';
import 'package:smart_health_v2/domain/data/doctors_collection.dart';

class Database {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  late CategoriesCollection _categoriesCollection;
  late DoctorsCollection _doctorsCollection;

  Database() {
    _categoriesCollection = CategoriesCollection(_firestore);
    _doctorsCollection = DoctorsCollection(_firestore);
  }

  CategoriesCollection get categoriesCollection => _categoriesCollection;
  DoctorsCollection get doctorsCollection => _doctorsCollection;
}
