import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:smart_health_v2/domain/interfaces/collection.dart';

class CategoriesCollection implements Collection {
  late CollectionReference _collection;

  CategoriesCollection(FirebaseFirestore firestore) {
    _collection = firestore.collection('categories');
  }

  Future<QuerySnapshot> getData() async {
    return await _collection.get();
  }

  Stream<DocumentSnapshot> getDataStream() {
    return _collection.doc().snapshots();
  }
}
