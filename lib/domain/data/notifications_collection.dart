import 'package:cloud_firestore/cloud_firestore.dart';

class NotificationsCollection {
  late CollectionReference _collection;
  late FirebaseFirestore _firestore;

  NotificationsCollection(FirebaseFirestore firestore) {
    _collection = firestore.collection('notifications');
    _firestore = firestore;
  }

  Future<QuerySnapshot> getData() async {
    return await _collection.get();
  }

  Stream<QuerySnapshot<Map<String, dynamic>>> getDataStream(String userEmail) {
    return _firestore
        .collection('notifications')
        .where('userEmail', isEqualTo: userEmail)
        .orderBy('time', descending: true)
        .snapshots();
  }
}
