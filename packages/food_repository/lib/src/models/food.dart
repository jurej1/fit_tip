import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

class Food extends Equatable {
  final String id;
  final String name;
  final DocumentReference sourceRef;
  final double amount;
  final double calories;

  Food({
    required this.id,
    required this.name,
    required this.sourceRef,
    required this.amount,
    required this.calories,
  });

  @override
  List<Object> get props => throw UnimplementedError();
}
