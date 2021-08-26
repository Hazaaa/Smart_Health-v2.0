import 'package:cloud_firestore/cloud_firestore.dart';

class PharmaciesCollection {
  late CollectionReference _collection;

  PharmaciesCollection(FirebaseFirestore firestore) {
    _collection = firestore.collection('pharmacies');
  }

  Future<QuerySnapshot> getData() async {
    return await _collection.get();
  }

  Stream<DocumentSnapshot> getDataStream() {
    return _collection.doc().snapshots();
  }
}
