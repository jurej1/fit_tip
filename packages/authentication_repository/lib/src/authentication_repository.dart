import 'package:authentication_repository/authentication_repository.dart';
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

  Stream<String?> get authenticationId {
    return _firebaseAuth.authStateChanges().map(
      (user) {
        if (user == null) return null;
        return user.uid;
      },
    );
  }

  Stream<model.User> user(String id) {
    return _firebaseFirestore.doc(id).snapshots().map((snap) => model.User.fromEntity(UserEntity.fromDocumentSnapshot(snap)));
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
      throw e;
    }
  }
}
