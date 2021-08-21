import 'package:cloud_firestore/cloud_firestore.dart';

class BlogRepository {
  final FirebaseFirestore _firebaseFirestore;

  BlogRepository({
    FirebaseFirestore? firebaseFirestore,
  }) : this._firebaseFirestore = firebaseFirestore ?? FirebaseFirestore.instance;
}
