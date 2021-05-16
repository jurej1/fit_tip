import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';

import '../enums/enums.dart';

class WaterCupEntity extends Equatable {
  final DrinkingCupSize size;
  final double amount;
  final String imagePath;

  const WaterCupEntity({
    required this.size,
    required this.amount,
    required this.imagePath,
  });

  @override
  List<Object> get props => [size, amount, imagePath];

  WaterCupEntity copyWith({
    DrinkingCupSize? size,
    double? amount,
    String? imagePath,
  }) {
    return WaterCupEntity(
      size: size ?? this.size,
      amount: amount ?? this.amount,
      imagePath: imagePath ?? this.imagePath,
    );
  }

  Map<String, dynamic> toDocumentSnapshot() {
    return {
      'amount': amount,
      'size': describeEnum(this.size),
    };
  }

  static WaterCupEntity fromDocumentSnapshot(DocumentSnapshot snap) {
    final data = snap.data() as Map;
    return WaterCupEntity(
      size: data['size'],
      amount: data['amount'],
      imagePath: data['imagePath'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'size': describeEnum(size),
      'amount': amount,
    };
  }

  factory WaterCupEntity.fromMap(Map<String, dynamic> map) {
    return WaterCupEntity(
      size: DrinkingCupSize.values.firstWhere((element) {
        return describeEnum(element) == map['size'];
      }),
      amount: map['amount'],
      imagePath: map['imagePath'],
    );
  }
}
