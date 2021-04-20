import 'package:authentication_repository/src/enums/enums.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';

import 'location_entity.dart' as loc;

class _DocKeys {
  static get dateJoined => 'dateJoined';
  static get gender => 'gender';
  static get firstName => 'firstName';
  static get lastName => 'lastName';
  static get displayName => 'displayName';
  static get birthdate => 'birthdate';
  static get email => 'email';
  static get height => 'height';
  static get weight => 'weight';
  static get measurmentSystem => 'measurmentSystem';
  static get introduction => 'introduction';
  static get location => 'location';
  static get id => 'id';
  static get lastInitial => 'lastInitial';
}

class UserEntity extends Equatable {
  final String? id;
  final Timestamp? dateJoined;
  final Gender? gender;
  final String? firstName;
  final String? lastName;
  final String? displayName;
  final Timestamp? birthdate;
  final String? email;
  final double? height;
  final double? weight;
  final MeasurmentSystem? measurmentSystem;
  final String? introduction;
  final loc.LocationEntity? location;
  final String? lastInitial;

  const UserEntity({
    this.id,
    this.dateJoined,
    this.gender,
    this.firstName,
    this.lastName,
    this.displayName,
    this.birthdate,
    this.email,
    this.height,
    this.weight,
    this.measurmentSystem,
    this.introduction,
    this.location,
    this.lastInitial,
  });

  static final empty = UserEntity(
    id: '',
    location: loc.LocationEntity.empty,
    height: 0,
    gender: Gender.ratherNotSay,
    measurmentSystem: MeasurmentSystem.metric,
    weight: 0,
    displayName: '',
  );

  UserEntity copyWith({
    String? id,
    Timestamp? dateJoined,
    Gender? gender,
    String? firstName,
    String? lastName,
    String? displayName,
    Timestamp? birthdate,
    String? email,
    double? height,
    double? weight,
    MeasurmentSystem? measurmentSystem,
    String? introduction,
    loc.LocationEntity? location,
    String? lastInitial,
  }) {
    return UserEntity(
      id: id ?? this.id,
      dateJoined: dateJoined ?? this.dateJoined,
      gender: gender ?? this.gender,
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      displayName: displayName ?? this.displayName,
      birthdate: birthdate ?? this.birthdate,
      email: email ?? this.email,
      height: height ?? this.height,
      weight: weight ?? this.weight,
      measurmentSystem: measurmentSystem ?? this.measurmentSystem,
      introduction: introduction ?? this.introduction,
      location: location ?? this.location,
      lastInitial: lastInitial ?? this.lastInitial,
    );
  }

  Map<String, dynamic> toDocumentSnapshot() {
    return {
      _DocKeys.birthdate: birthdate,
      _DocKeys.dateJoined: dateJoined,
      _DocKeys.displayName: displayName,
      _DocKeys.email: email,
      _DocKeys.firstName: firstName,
      _DocKeys.gender: gender != null ? describeEnum(gender!) : null,
      _DocKeys.height: height,
      _DocKeys.introduction: introduction,
      _DocKeys.lastInitial: lastInitial,
      _DocKeys.lastName: lastName,
      _DocKeys.location: location != null ? location!.toDocumentSnapshot() : null,
      _DocKeys.measurmentSystem: location != null ? describeEnum(measurmentSystem!) : null,
      _DocKeys.weight: weight,
    };
  }

  factory UserEntity.fromDocumentSnapshot(DocumentSnapshot snap) {
    final data = snap.data();
    if (data == null) return UserEntity.empty;

    return UserEntity(
      displayName: data[_DocKeys.displayName],
      id: snap.id,
      gender: stringToGender(data[_DocKeys.gender]),
      height: data[_DocKeys.height],
      location: loc.LocationEntity.fromJson(data[_DocKeys.location]),
      measurmentSystem: stringToMeasurmentSystem(data[_DocKeys.measurmentSystem]),
      weight: data[_DocKeys.weight],
      birthdate: data[_DocKeys.birthdate],
      dateJoined: data[_DocKeys.dateJoined],
      email: data[_DocKeys.email],
      firstName: data[_DocKeys.firstName],
      introduction: data[_DocKeys.introduction],
      lastInitial: data[_DocKeys.lastInitial],
      lastName: data[_DocKeys.lastName],
    );
  }

  @override
  List<Object?> get props {
    return [
      id,
      dateJoined,
      gender,
      firstName,
      lastName,
      displayName,
      birthdate,
      email,
      height,
      weight,
      measurmentSystem,
      introduction,
      location,
      lastInitial,
    ];
  }
}
