import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

class FoodDataEntity extends Equatable {
  final double? amount;
  final String name;

  const FoodDataEntity({
    this.amount,
    required this.name,
  });

  @override
  List<Object?> get props => [amount, name];

  FoodDataEntity copyWith({
    double? amount,
    String? name,
  }) {
    return FoodDataEntity(
      amount: amount ?? this.amount,
      name: name ?? this.name,
    );
  }

  Map<String, dynamic> toDocumentSnapshot() {
    return {
      'amount': amount,
      'name': name,
    };
  }

  static FoodDataEntity fromDocumentSnapshot(DocumentSnapshot snap) {
    final data = snap.data() as Map<String, dynamic>;

    return FoodDataEntity(
      name: data['name'],
      amount: data['amount'],
    );
  }
}
