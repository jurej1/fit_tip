part of 'water_log_amount_slider_bloc.dart';

class WaterLogAmountSliderState extends Equatable {
  const WaterLogAmountSliderState({
    required this.currentAmount,
    required this.minAmount,
    required this.maxAmount,
  });

  final int currentAmount;
  final int minAmount;
  final int maxAmount;

  @override
  List<Object> get props => [currentAmount, minAmount, maxAmount];

  WaterLogAmountSliderState copyWith({
    int? currentAmount,
    int? minAmount,
    int? maxAmount,
  }) {
    return WaterLogAmountSliderState(
      currentAmount: currentAmount ?? this.currentAmount,
      minAmount: minAmount ?? this.minAmount,
      maxAmount: maxAmount ?? this.maxAmount,
    );
  }
}
