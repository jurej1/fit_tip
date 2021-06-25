import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:food_repository/food_repository.dart';
import 'package:food_repository/src/entity/entity.dart';

class FoodRepository {
  final FirebaseFirestore _firebaseFirestore;

  FoodRepository({FirebaseFirestore? firebaseFirestore}) : _firebaseFirestore = firebaseFirestore ?? FirebaseFirestore.instance;

  CollectionReference _mealTrackingRef(String userId) {
    return _firebaseFirestore.collection('users').doc(userId).collection('meal_tracking');
  }

  CollectionReference _goalTrackingRef(String userId) {
    return _firebaseFirestore.collection('users').doc(userId).collection('meal_goals');
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
    return _mealTrackingRef(userId).doc(foodItem.id).set(foodItem.toEntity().toDocumentSnapshot(), SetOptions(merge: true));
  }

  Future<Meal> getMealFodSpecificDay(String userId, DateTime date, MealType type) async {
    DateTime lowerBound = DateTime(date.year, date.month, date.day, 0, 0, 0);
    DateTime upperBound = DateTime(date.year, date.month, date.day, 23, 59, 59);

    try {
      QuerySnapshot snapshot = await _mealTrackingRef(userId)
          .where('dateAdded', isGreaterThanOrEqualTo: lowerBound, isLessThanOrEqualTo: upperBound)
          .where('mealType', isEqualTo: describeEnum(type))
          .get();

      return Meal(
        date: date,
        type: type,
        foods: snapshot.size == 0 ? [] : snapshot.docs.map((e) => FoodItem.fromEntity(FoodItemEntity.fromDocumentSnapshot(e))).toList(),
      );
    } on Exception catch (e) {
      throw e;
    }
  }

  Future<MealDay?> getMealDayForSpecificDay(String userId, DateTime date) async {
    final DateTime lowerBound = DateTime(date.year, date.month, date.day, 0, 0, 0);
    final DateTime upperBound = DateTime(date.year, date.month, date.day, 23, 59, 59);

    try {
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
    } on Exception catch (e) {
      throw e;
    }
  }

  Future<CalorieDailyGoal> getCalorieDailyGoalForSpecificDate(String userId, DateTime date) async {
    String calGoalId = CalorieDailyGoalEntity.generateId(date);

    try {
      DocumentSnapshot snapshot = await _goalTrackingRef(userId).doc(calGoalId).get();

      if (snapshot.exists && snapshot.data() != null) {
        return CalorieDailyGoal.fromEntity(CalorieDailyGoalEntity.fromDocumentSnapshot(snapshot));
      } else {
        DateTime dayStart = DateTime(date.year, date.month, date.day, 0, 0, 0);
        QuerySnapshot querySnapshot =
            await _goalTrackingRef(userId).orderBy('date', descending: true).where('date', isLessThan: dayStart).limit(1).get();

        if (querySnapshot.size == 0) {
          CalorieDailyGoal goal = CalorieDailyGoal(amount: 2200, date: date, fats: 55, carbs: 250, proteins: 52);

          addCalorieDailyGoal(userId, goal);
          return goal;
        } else {
          CalorieDailyGoal goal = CalorieDailyGoal.fromEntity(
            CalorieDailyGoalEntity.fromDocumentSnapshot(
              querySnapshot.docs.first,
            ),
          ).copyWith(date: date, id: CalorieDailyGoal.generateId(date));
          addCalorieDailyGoal(userId, goal);
          return goal;
        }
      }
    } on Exception catch (e) {
      throw e;
    }
  }

  Future<void> addCalorieDailyGoal(String userId, CalorieDailyGoal calorieDailyGoal) {
    return _goalTrackingRef(userId).doc(calorieDailyGoal.id).set(calorieDailyGoal.toEntity().toDocumentSnapshot());
  }

  Future<void> deleteCalorieDailyGoal(String userId, CalorieDailyGoal calorieDailyGoal) {
    return _goalTrackingRef(userId).doc(calorieDailyGoal.id).delete();
  }

  Future<void> updateCalorieDailyGoal(String userId, CalorieDailyGoal calorieDailyGoal) {
    return _goalTrackingRef(userId).doc(calorieDailyGoal.id).set(
          calorieDailyGoal.toEntity().toDocumentSnapshot(),
          SetOptions(merge: true),
        );
  }
}
