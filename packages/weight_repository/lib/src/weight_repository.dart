import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class WeightRepository {
  WeightRepository({FirebaseFirestore? firebaseFirestore, FirebaseAuth? firebaseAuth})
      : _firebaseFirestore = firebaseFirestore ?? FirebaseFirestore.instance,
        _firebaseAuth = firebaseAuth ?? FirebaseAuth.instance;

  final FirebaseFirestore _firebaseFirestore;
  final FirebaseAuth _firebaseAuth;
}
