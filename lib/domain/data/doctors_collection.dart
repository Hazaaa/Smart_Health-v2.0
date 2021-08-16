import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:smart_health_v2/domain/interfaces/collection.dart';

class DoctorsCollection implements Collection {
  late CollectionReference _collection;

  DoctorsCollection(FirebaseFirestore firestore) {
    _collection = firestore.collection('doctors');
  }

  Future<QuerySnapshot> getData() async {
    return await _collection.get();
  }

  Stream<DocumentSnapshot> getDataStream() {
    return _collection.doc().snapshots();
  }
}
