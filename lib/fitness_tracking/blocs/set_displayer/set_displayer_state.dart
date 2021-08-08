part of 'set_displayer_cubit.dart';

class SetDisplayerState extends Equatable {
  const SetDisplayerState({
    required this.repAmount,
    required this.weightAmount,
    required this.setIndex,
  });

  final int repAmount;
  final double weightAmount;
  final int setIndex;
  @override
  List<Object> get props => [repAmount, weightAmount, setIndex];

  SetDisplayerState copyWith({
    int? repAmount,
    double? weightAmount,
    int? setIndex,
  }) {
    return SetDisplayerState(
      repAmount: repAmount ?? this.repAmount,
      weightAmount: weightAmount ?? this.weightAmount,
      setIndex: setIndex ?? this.setIndex,
    );
  }
}
