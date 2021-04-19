import 'package:authentication_repository/src/entity/entity.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../src/models/models.dart' as model;

enum AuthenticationStatus { unknown, authenticated, unauthenticated }

class AuthenticationRepository {
  final FirebaseAuth _firebaseAuth;
  final FirebaseFirestore _firebaseFirestore;

  AuthenticationRepository({FirebaseAuth? firebaseAuth, FirebaseFirestore? firebaseFirestore})
      : _firebaseAuth = firebaseAuth ?? FirebaseAuth.instance,
        _firebaseFirestore = firebaseFirestore ?? FirebaseFirestore.instance;

  Stream<AuthenticationStatus> get authenticationStatus {
    return _firebaseAuth.authStateChanges().map(
      (user) {
        if (user == null) return AuthenticationStatus.unauthenticated;
        return AuthenticationStatus.unauthenticated;
      },
    );
  }

  String? get currentUserId => _firebaseAuth.currentUser?.uid;

  Stream<model.User>? get user {
    final String? id = currentUserId;

    if (id == null) return null;

    return _firebaseFirestore.doc(id).snapshots().map((snap) => model.User.fromEntity(UserEntity.fromDocumentSnapshot(snap)));
  }

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
}
