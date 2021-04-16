import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

enum AuthenticationStatus { unknown, authenticated, unauthenticated }

class AuthenticationRepository {
  final FirebaseAuth _firebaseAuth;
  final FirebaseFirestore _firebaseFirestore;

  AuthenticationRepository({FirebaseAuth? firebaseAuth, FirebaseFirestore? firebaseFirestore})
      : _firebaseAuth = firebaseAuth ?? FirebaseAuth.instance,
        _firebaseFirestore = firebaseFirestore ?? FirebaseFirestore.instance;

  Stream<User?> get user {
    return _firebaseAuth.authStateChanges();
  }

  User? get currentUser => _firebaseAuth.currentUser;

  Future<UserCredential> loginWithEmailAndPassword({required String email, required String password}) async {
    return _firebaseAuth.signInWithEmailAndPassword(email: email, password: password);
  }

  Future<UserCredential> createUserWithEmailAndPassword({required String email, required String password}) async {
    return _firebaseAuth.createUserWithEmailAndPassword(email: email, password: password);
  }

  Future<void> updateUserProfile({String? displayName, String? photoUrl}) async {
    final User? user = currentUser;
    if (user == null) {
      return;
    }

    return user.updateProfile(displayName: displayName, photoURL: photoUrl);
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
