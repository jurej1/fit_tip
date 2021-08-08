part of 'excercise_page_card_bloc.dart';

abstract class ExcercisePageCardEvent extends Equatable {
  const ExcercisePageCardEvent();

  @override
  List<Object> get props => [];
}

class ExcercisePageRepCountUpdated extends ExcercisePageCardEvent {
  final int value;
  final int setIndex;

  const ExcercisePageRepCountUpdated({
    required this.value,
    required this.setIndex,
  });
  @override
  List<Object> get props => [value, setIndex];
}

class ExcercisePageWeightCountUpdated extends ExcercisePageCardEvent {
  final double value;
  final int setIndex;

  const ExcercisePageWeightCountUpdated({
    required this.value,
    required this.setIndex,
  });

  @override
  List<Object> get props => [value, setIndex];
}
