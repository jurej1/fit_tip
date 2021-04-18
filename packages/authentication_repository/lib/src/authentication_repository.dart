import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

enum AuthenticationStatus { unknown, authenticated, unauthenticated }

class AuthenticationRepository {
  final FirebaseAuth _firebaseAuth;
  final FirebaseFirestore _firebaseFirestore;

  AuthenticationRepository({FirebaseAuth? firebaseAuth, FirebaseFirestore? firebaseFirestore})
      : _firebaseAuth = firebaseAuth ?? FirebaseAuth.instance,
        _firebaseFirestore = firebaseFirestore ?? FirebaseFirestore.instance {}

  Stream get authenticationStatus {
    return _firebaseAuth.authStateChanges().map((user) {
      if (user == null) {
        return AuthenticationStatus.unauthenticated;
      }
      return AuthenticationStatus.authenticated;
    });
  }

  User? get currentUser => _firebaseAuth.currentUser;

  Future<UserCredential> loginWithEmailAndPassword({required String email, required String password}) async {
    return _firebaseAuth.signInWithEmailAndPassword(email: email, password: password);
  }

  Future<UserCredential> createUserWithEmailAndPassword({required String email, required String password}) async {
    try {
      final UserCredential userCredential = await _firebaseAuth.createUserWithEmailAndPassword(email: email, password: password);

      return userCredential;
    } catch (e) {
      throw e;
    }
  }

  Future<void> updateEmail({required String newEmail}) async {
    final User? user = currentUser;

    if (user != null) {
      return user.updateEmail(newEmail);
    }
    return;
  }

  Future<void> updatePassword({required String newPassword}) async {
    final User? user = currentUser;

    if (user != null) {
      return user.updatePassword(newPassword);
    }
    return;
  }
}
