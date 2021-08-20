import 'package:cloud_firestore/cloud_firestore.dart';

class DoctorsCollection {
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
