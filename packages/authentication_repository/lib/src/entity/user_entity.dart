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
  static get measurmentSystem => 'measurmentSystem';
  static get introduction => 'introduction';
  static get location => 'location';
  static get id => 'id';
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
  final MeasurmentSystem measurmentSystem;
  final String? introduction;
  final loc.LocationEntity? location;

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
    this.measurmentSystem = MeasurmentSystem.metric,
    this.introduction,
    this.location,
  });

  static final empty = UserEntity(
    id: '',
    location: loc.LocationEntity.empty,
    height: 0,
    gender: Gender.ratherNotSay,
    measurmentSystem: MeasurmentSystem.metric,
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
    MeasurmentSystem? measurmentSystem,
    String? introduction,
    loc.LocationEntity? location,
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
      measurmentSystem: measurmentSystem ?? this.measurmentSystem,
      introduction: introduction ?? this.introduction,
      location: location ?? this.location,
    );
  }

  Map<String, dynamic> toDocumentSnapshot() {
    return {
      if (birthdate != null) _DocKeys.birthdate: birthdate,
      if (dateJoined != null) _DocKeys.dateJoined: dateJoined,
      if (displayName != null) _DocKeys.displayName: displayName,
      if (email != null) _DocKeys.email: email,
      if (firstName != null) _DocKeys.firstName: firstName,
      if (gender != null) _DocKeys.gender: describeEnum(gender!),
      if (height != null) _DocKeys.height: height,
      if (introduction != null) _DocKeys.introduction: introduction,
      if (lastName != null) _DocKeys.lastName: lastName,
      if (location != null) _DocKeys.location: location!.toDocumentSnapshot(),
      _DocKeys.measurmentSystem: describeEnum(measurmentSystem),
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
      location: loc.LocationEntity.fromDocumentSnapshot(data[_DocKeys.location]),
      measurmentSystem: stringToMeasurmentSystem(data[_DocKeys.measurmentSystem]),
      birthdate: data[_DocKeys.birthdate],
      dateJoined: data[_DocKeys.dateJoined],
      email: data[_DocKeys.email],
      firstName: data[_DocKeys.firstName],
      introduction: data[_DocKeys.introduction],
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
      measurmentSystem,
      introduction,
      location,
    ];
  }
}
