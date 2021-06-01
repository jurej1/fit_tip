import 'package:cloud_firestore/cloud_firestore.dart';

class WaterRepository {
  final FirebaseFirestore _firebaseFirestore;

  WaterRepository({FirebaseFirestore? firebaseFirestore}) : _firebaseFirestore = firebaseFirestore ?? FirebaseFirestore.instance;
}
