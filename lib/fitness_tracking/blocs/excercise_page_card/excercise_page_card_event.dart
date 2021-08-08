part of 'excercise_page_card_bloc.dart';

abstract class ExcercisePageCardEvent extends Equatable {
  const ExcercisePageCardEvent();

  @override
  List<Object> get props => [];
}

class ExcercisePageRepCountUpdated extends ExcercisePageCardEvent {
  final int value;
  final int repIndex;

  const ExcercisePageRepCountUpdated({
    required this.value,
    required this.repIndex,
  });
  @override
  List<Object> get props => [value, repIndex];
}

class ExcercisePageWeightCountUpdated extends ExcercisePageCardEvent {
  final int value;
  final int repIndex;

  const ExcercisePageWeightCountUpdated({
    required this.value,
    required this.repIndex,
  });

  @override
  List<Object> get props => [value, repIndex];
}
