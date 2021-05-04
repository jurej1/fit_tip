part of 'measurment_system_bloc.dart';

abstract class MeasurmentSystemEvent extends Equatable {
  const MeasurmentSystemEvent();

  @override
  List<Object?> get props => [];
}

class MeasurmentSystemUpdated extends MeasurmentSystemEvent {
  final MeasurmentSystem? system;

  MeasurmentSystemUpdated({this.system});

  @override
  List<Object?> get props => [system];
}
