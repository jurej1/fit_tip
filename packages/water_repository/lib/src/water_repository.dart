import 'package:cloud_firestore/cloud_firestore.dart';

class WaterRepository {
  WaterRepository({
    FirebaseFirestore? firebaseFirestore,
  }) : _firebaseFirestore = firebaseFirestore ?? FirebaseFirestore.instance;

  late final FirebaseFirestore _firebaseFirestore;
}
