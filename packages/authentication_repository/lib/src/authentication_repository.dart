import 'package:authentication_repository/authentication_repository.dart';
import 'package:authentication_repository/src/entity/entity.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../src/models/models.dart' as model;

enum AuthenticationStatus { unknown, authenticated, unauthenticated }

extension AuthenticationStatusX on AuthenticationStatus {
  bool get isAuthenticated => this == AuthenticationStatus.authenticated;
}

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
        return AuthenticationStatus.authenticated;
      },
    );
  }

  String? get _currentUserId => _firebaseAuth.currentUser?.uid;

  Stream<model.User>? get user {
    final String? id = _currentUserId;

    if (id == null) return null;

    return _firebaseFirestore
        .collection('users')
        .doc(id)
        .snapshots()
        .map((snap) => model.User.fromEntity(UserEntity.fromDocumentSnapshot(snap)));
  }

  Future<void> logOut() {
    return _firebaseAuth.signOut();
  }

  Future<UserCredential> loginWithEmailAndPassword({required String email, required String password}) async {
    return _firebaseAuth.signInWithEmailAndPassword(email: email, password: password);
  }

  Future<UserCredential> createUserWithEmailAndPassword({required String email, required String password}) async {
    try {
      final UserCredential userCredential = await _firebaseAuth.createUserWithEmailAndPassword(email: email, password: password);

      final user = userCredential.user;

      if (user != null) {
        await _firebaseFirestore.collection('users').doc(user.uid).set(
              model.User(
                dateJoined: DateTime.now(),
                email: user.email,
                measurmentSystem: MeasurmentSystem.metric,
                introduction: 'Hey! I am using FitTip',
              ).toEntity().toDocumentSnapshot(),
            );
      }

      return userCredential;
    } catch (e) {
      print('Create error $e');
      throw e;
    }
  }

  Future<void> updateMeasurmentSystem(MeasurmentSystem system) async {
    if (_currentUserId == null) return;

    return _firebaseFirestore
        .collection('users')
        .doc(_currentUserId!)
        .update(model.User(measurmentSystem: system).toEntity().toDocumentSnapshot());
  }

  Future<void> updatedUserData(model.User user) async {
    return _firebaseFirestore.collection('users').doc(user.id).set(
          user.toEntity().toDocumentSnapshot(),
        );
  }

  Future<void> updateUserEmail(String email) async {
    return _firebaseAuth.currentUser!.updateEmail(email);
  }
}
