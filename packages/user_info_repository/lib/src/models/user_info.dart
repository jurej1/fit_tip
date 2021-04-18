import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:user_info_repository/src/entity/entity.dart';
import 'package:user_info_repository/src/enums/enums.dart';

import '../models/models.dart' as model;

class UserInfo extends Equatable {
  final DateTime? dateJoined;
  final String? id;
  final Gender? gender;
  final String? firstName;
  final String? lastName;
  final String? displayName;
  final DateTime? birthdate;
  final String? email;
  final double? height;
  final double? weight;
  final MeasurmentSystem? measurmentSystem;
  final String? introduction;
  final model.Location? location;
  final String? lastInitial;

  const UserInfo({
    this.dateJoined,
    this.id,
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
      weight,
      measurmentSystem,
      introduction,
      location,
      lastInitial,
    ];
  }

  UserInfo copyWith({
    DateTime? dateJoined,
    String? id,
    Gender? gender,
    String? firstName,
    String? lastName,
    String? displayName,
    DateTime? birthdate,
    String? email,
    double? height,
    double? weight,
    MeasurmentSystem? measurmentSystem,
    String? introduction,
    model.Location? location,
    String? lastInitial,
  }) {
    return UserInfo(
      dateJoined: dateJoined ?? this.dateJoined,
      id: id ?? this.id,
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

  UserInfoEntity toEntity() {
    return UserInfoEntity(
      displayName: displayName,
      gender: gender,
      height: height,
      id: id,
      location: location?.toEntity(),
      measurmentSystem: measurmentSystem,
      weight: weight,
      birthdate: birthdate != null ? Timestamp.fromDate(birthdate!) : null,
      dateJoined: dateJoined != null ? Timestamp.fromDate(dateJoined!) : null,
      email: email,
      firstName: firstName,
      introduction: introduction,
      lastInitial: lastInitial,
      lastName: lastName,
    );
  }

  factory UserInfo.fromEntity(UserInfoEntity val) {
    return UserInfo(
      dateJoined: val.dateJoined?.toDate(),
      displayName: val.displayName,
      gender: val.gender,
      height: val.height,
      id: val.id,
      location: val.location != null ? model.Location.formEntity(val.location!) : null,
      measurmentSystem: val.measurmentSystem,
      weight: val.weight,
      birthdate: val.birthdate?.toDate(),
      email: val.email,
      firstName: val.firstName,
      introduction: val.introduction,
      lastInitial: val.lastInitial,
      lastName: val.lastName,
    );
  }
}
