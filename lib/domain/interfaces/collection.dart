import 'package:cloud_firestore/cloud_firestore.dart';

abstract class Collection {
  /// Returns data from the firestore but only once. */
  Future<QuerySnapshot> getData();

  /// Returns stream for getting data from the firestore that will return snapshot everytime something change in db. */
  Stream<DocumentSnapshot> getDataStream();
}
