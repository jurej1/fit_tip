import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:food_repository/food_repository.dart';
import 'package:food_repository/src/entity/entity.dart';

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

  Future<DocumentReference> addFoodItem(String userId, FoodItem foodItem) async {
    return _mealTrackingRef(userId).add(foodItem.toEntity().toDocumentSnapshot());
  }

  Future<void> deleteFoodItem(String userId, FoodItem foodItem) async {
    return _mealTrackingRef(userId).doc(foodItem.id).delete();
  }

  Future<void> updateFoodItem(String userId, FoodItem foodItem) async {
    return _mealTrackingRef(userId).doc(userId).set(foodItem.toEntity().toDocumentSnapshot(), SetOptions(merge: true));
  }

  Future<Meal> getMealFodSpecificDay(String userId, DateTime date, MealType type) async {
    DateTime lowerBound = DateTime(date.year, date.month, date.day, 0, 0, 0);
    DateTime upperBound = DateTime(date.year, date.month, date.day, 23, 59, 59);

    QuerySnapshot snapshot = await _mealTrackingRef(userId)
        .where('dateAdded', isGreaterThanOrEqualTo: lowerBound, isLessThanOrEqualTo: upperBound)
        .where('mealType', isEqualTo: describeEnum(type))
        .get();

    return Meal(
      date: date,
      type: type,
      foods: snapshot.docs.map((e) => FoodItem.fromEntity(FoodItemEntity.fromDocumentSnapshot(e))).toList(),
    );
  }

  Future<MealDay?> getMealDayForSpecificDay(String userId, DateTime date) async {
    final DateTime lowerBound = DateTime(date.year, date.month, date.day, 0, 0, 0);
    final DateTime upperBound = DateTime(date.year, date.month, date.year, 23, 59, 59);

    QuerySnapshot snapshot = await _mealTrackingRef(userId)
        .where('dateAdded')
        .where('dateAdded', isGreaterThanOrEqualTo: lowerBound, isLessThanOrEqualTo: upperBound)
        .get();

    if (snapshot.size == 0) {
      return null;
    } else {
      List<FoodItem> foods = snapshot.docs.map((e) => FoodItem.fromEntity(FoodItemEntity.fromDocumentSnapshot(e))).toList();

      return MealDay(
        breakfast: Meal(
          date: date,
          type: MealType.breakfast,
          foods: foods.where((element) => element.mealType == MealType.breakfast).toList(),
        ),
        dinner: Meal(
          date: date,
          type: MealType.dinner,
          foods: foods.where((element) => element.mealType == MealType.dinner).toList(),
        ),
        lunch: Meal(
          date: date,
          type: MealType.lunch,
          foods: foods.where((element) => element.mealType == MealType.lunch).toList(),
        ),
        snacks: Meal(
          date: date,
          type: MealType.snack,
          foods: foods.where((element) => element.mealType == MealType.snack).toList(),
        ),
      );
    }
  }
}
