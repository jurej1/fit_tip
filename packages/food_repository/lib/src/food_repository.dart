import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:food_repository/food_repository.dart';

class WaterRepository {
  final FirebaseFirestore _firebaseFirestore;

  WaterRepository({FirebaseFirestore? firebaseFirestore}) : _firebaseFirestore = firebaseFirestore ?? FirebaseFirestore.instance;

  CollectionReference _mealTrackingRef(String userId) {
    return _firebaseFirestore.collection('users').doc(userId).collection('meal_tracking');
  }

  Future<void> addMeal(String userId, Meal meal) async {
    List<FoodItem> items = meal.foods.map((e) => e.copyWith(dateAdded: meal.date, mealType: meal.type)).toList();

    for (int i = 0; i < items.length; i++) {
      await _mealTrackingRef(userId).add(items[i].toEntity().toDocumentSnapshot());
    }
  }
}
