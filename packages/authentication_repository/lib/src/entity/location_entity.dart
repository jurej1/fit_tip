import 'package:equatable/equatable.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class _DocKeys {
  static get country => 'country';
  static get region => 'region';
  static get locality => 'locality';
}

class LocationEntity extends Equatable {
  final String country;
  final String? region;
  final String? locality;

  const LocationEntity({
    required this.country,
    this.region,
    this.locality,
  });

  static const empty = LocationEntity(country: '');

  @override
  List<Object?> get props => [country, region, locality];

  LocationEntity copyWith({
    String? country,
    String? region,
    String? locality,
  }) {
    return LocationEntity(
      country: country ?? this.country,
      region: region ?? this.region,
      locality: locality ?? this.locality,
    );
  }

  Map<String, dynamic> toDocumentSnapshot() {
    return {
      _DocKeys.country: country,
      _DocKeys.region: region,
      _DocKeys.locality: locality,
    };
  }

  static LocationEntity? fromDocumentSnapshot(DocumentSnapshot? snap) {
    if (snap == null) return null;

    final data = snap.data();

    if (data == null) return null;

    return LocationEntity(
      country: data.containsKey(_DocKeys.country) ? data[_DocKeys.country] : '',
      locality: data[_DocKeys.locality],
      region: data[_DocKeys.region],
    );
  }

  factory LocationEntity.fromJson(Map<String, dynamic> data) {
    return LocationEntity(
      country: data[_DocKeys.country],
      locality: data[_DocKeys.locality],
      region: data[_DocKeys.region],
    );
  }
}
