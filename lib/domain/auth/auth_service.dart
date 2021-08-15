import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'package:flutter/material.dart';
import 'package:smart_health_v2/domain/auth/models/health_card.dart';
import 'package:smart_health_v2/domain/auth/models/user.dart';

class AuthService with ChangeNotifier {
  final auth.FirebaseAuth _firebaseAuth = auth.FirebaseAuth.instance;
  bool _signinInProgress = false;
  String? _errorMessage;

  bool get isSigningInProgress => _signinInProgress;
  String get errorMessage => _errorMessage ?? '';

  User? mapUserFromFirebase(auth.User? user) {
    if (user == null) {
      return null;
    }

    return User(user.uid, user.email);
  }

  Stream<User?>? get user {
    return _firebaseAuth.authStateChanges().map(mapUserFromFirebase);
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
