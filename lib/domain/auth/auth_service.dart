import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'package:flutter/material.dart';
import 'package:smart_health_v2/domain/auth/models/health_card.dart';
import 'package:smart_health_v2/domain/auth/models/user.dart';
import 'package:smart_health_v2/domain/auth/models/user_details.dart';

class AuthService with ChangeNotifier {
  final auth.FirebaseAuth _firebaseAuth = auth.FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  bool _signinInProgress = false;
  String? _errorMessage;

  bool get isSigningInProgress => _signinInProgress;
  String get errorMessage => _errorMessage ?? '';
  auth.FirebaseAuth get firebaseAuthInstance => _firebaseAuth;

  User? currentUser;

  User? mapUserFromFirebase(auth.User? user) {
    if (user == null) {
      return null;
    }

    User loggedUser = User(user.uid, user.email);

    return loggedUser;
  }

  User? get user {
    if (currentUser == null) {
      currentUser = mapUserFromFirebase(_firebaseAuth.currentUser);
    }

    return currentUser;
  }

  Future<DocumentSnapshot> get userDetails {
    return _firestore
        .collection('userDetails')
        .doc(_firebaseAuth.currentUser!.uid)
        .get();
  }

  Future<void> signInWithCardNumberAndPassword(
    HealthCard userHealthCard,
  ) async {
    try {
      _signinInProgress = true;
      _errorMessage = '';
      notifyListeners();
      // ignore: unused_local_variable
      final credentials = await _firebaseAuth.signInWithEmailAndPassword(
          email: userHealthCard.cardNumberAsEmail,
          password: userHealthCard.cardPassword);
    } on auth.FirebaseAuthException catch (e) {
      handleFirebaseException(e);
    } finally {
      _signinInProgress = false;
      notifyListeners();
    }
  }

  Future<void> signOutUser() async {
    await _firebaseAuth.signOut();
  }

  void handleFirebaseException(auth.FirebaseAuthException ex) {
    if (ex.code == 'user-not-found') {
      _errorMessage = "Ne postoji korisnik sa unetim podacima!";
    } else if (ex.code == 'wrong-password') {
      _errorMessage = "Pogrešna šifra!";
    } else {
      _errorMessage =
          "Došlo je do greške prilikom prijavljivanja! Pokušajte ponovo za par minuta!";
    }
    notifyListeners();
  }
}
