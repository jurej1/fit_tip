import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

class WaterGoalDailyEntity extends Equatable {
  final double dailyGoal;

  const WaterGoalDailyEntity({
    required this.dailyGoal,
  });

  @override
  List<Object?> get props => [dailyGoal];

  Map<String, dynamic> toDocumentSnapshot() {
    return {
      'goal': dailyGoal,
    };
  }

  static WaterGoalDailyEntity fromDocumentSnapshot(DocumentSnapshot snap) {
    final data = snap.data() as Map;

    return WaterGoalDailyEntity(dailyGoal: data['goal']);
  }
}
