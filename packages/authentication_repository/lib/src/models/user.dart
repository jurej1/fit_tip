import 'package:authentication_repository/src/entity/entity.dart';
import 'package:authentication_repository/src/enums/enums.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

import '../models/models.dart' as model;

class User extends Equatable {
  final DateTime? dateJoined;
  final String? id;
  final Gender? gender;
  final String? firstName;
  final String? lastName;
  final String? displayName;
  final DateTime? birthdate;
  final String? email;
  final double? height;
  final MeasurmentSystem measurmentSystem;
  final String? introduction;
  final model.Location? location;

  const User({
    this.dateJoined,
    this.id,
    this.gender,
    this.firstName,
    this.lastName,
    this.displayName,
    this.birthdate,
    this.email,
    this.height,
    this.measurmentSystem = MeasurmentSystem.metric,
    this.introduction,
    this.location,
  });

  User copyWith({
    DateTime? dateJoined,
    String? id,
    Gender? gender,
    String? firstName,
    String? lastName,
    String? displayName,
    DateTime? birthdate,
    String? email,
    double? height,
    MeasurmentSystem? measurmentSystem,
    String? introduction,
    model.Location? location,
  }) {
    return User(
      dateJoined: dateJoined ?? this.dateJoined,
      id: id ?? this.id,
      gender: gender ?? this.gender,
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      displayName: displayName ?? this.displayName,
      birthdate: birthdate ?? this.birthdate,
      email: email ?? this.email,
      height: height ?? this.height,
      measurmentSystem: measurmentSystem ?? this.measurmentSystem,
      introduction: introduction ?? this.introduction,
      location: location ?? this.location,
    );
  }

  UserEntity toEntity() {
    return UserEntity(
      displayName: displayName,
      gender: gender,
      height: height,
      id: id,
      location: location?.toEntity(),
      measurmentSystem: measurmentSystem,
      birthdate: birthdate != null ? Timestamp.fromDate(birthdate!) : null,
      dateJoined: dateJoined != null ? Timestamp.fromDate(dateJoined!) : null,
      email: email,
      firstName: firstName,
      introduction: introduction,
      lastName: lastName,
    );
  }

  factory User.fromEntity(UserEntity val) {
    return User(
      dateJoined: val.dateJoined?.toDate(),
      displayName: val.displayName,
      gender: val.gender,
      height: val.height,
      id: val.id,
      location: val.location != null ? model.Location.formEntity(val.location!) : null,
      measurmentSystem: val.measurmentSystem,
      birthdate: val.birthdate?.toDate(),
      email: val.email,
      firstName: val.firstName,
      introduction: val.introduction,
      lastName: val.lastName,
    );
  }

  @override
  List<Object?> get props {
    return [
      dateJoined,
      id,
      gender,
      firstName,
      lastName,
      displayName,
      birthdate,
      email,
      height,
      measurmentSystem,
      introduction,
      location,
    ];
  }
}
