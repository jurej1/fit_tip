import 'package:authentication_repository/src/entity/entity.dart';
import 'package:equatable/equatable.dart';

class Location extends Equatable {
  final String country;
  final String? region;
  final String? locality;

  const Location({
    required this.country,
    this.region,
    this.locality,
  });

  @override
  List<Object?> get props => [country, region, locality];

  Location copyWith({
    String? country,
    String? region,
    String? locality,
  }) {
    return Location(
      country: country ?? this.country,
      region: region ?? this.region,
      locality: locality ?? this.locality,
    );
  }

  LocationEntity toEntity() {
    return LocationEntity(
      country: country,
      locality: locality,
      region: region,
    );
  }

  factory Location.formEntity(LocationEntity entity) {
    return Location(
      country: entity.country,
      locality: entity.locality,
      region: entity.region,
    );
  }
}
