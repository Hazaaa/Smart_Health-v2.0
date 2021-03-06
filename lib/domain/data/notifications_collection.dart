import 'package:cloud_firestore/cloud_firestore.dart';

class NotificationsCollection {
  late CollectionReference _collection;
  late FirebaseFirestore _firestore;

  NotificationsCollection(FirebaseFirestore firestore) {
    _collection = firestore.collection('notifications');
    _firestore = firestore;
  }

  CollectionReference get collectionRef => _collection;

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

  Future<void> updateNotificationStatus(String notificationId, String status) {
    return _collection.doc(notificationId).update({'status': status});
  }

  Stream<DocumentSnapshot> getNotification(String notificationId) {
    return _collection.doc(notificationId).snapshots();
  }
}
