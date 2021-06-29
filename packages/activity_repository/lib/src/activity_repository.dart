import 'package:cloud_firestore/cloud_firestore.dart';

class ActivityRepository {
  final FirebaseFirestore _firebaseFirestore;

  ActivityRepository({FirebaseFirestore? firebaseFirestore}) : this._firebaseFirestore = firebaseFirestore ?? FirebaseFirestore.instance;
}
