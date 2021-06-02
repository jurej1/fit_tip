part of 'food_log_focused_date_bloc.dart';

class FoodLogFocusedDateState extends Equatable {
  FoodLogFocusedDateState({
    DateTime? selectedDate,
  }) : this.selectedDate = selectedDate ?? DateTime.now();

  final DateTime selectedDate;

  @override
  List<Object> get props => [selectedDate];

  bool get isSelectedDayToday {
    final DateTime now = DateTime.now();

    final DateTime today = DateTime(now.year, now.month, now.day);
    final DateTime selectedDate = DateTime(this.selectedDate.year, this.selectedDate.month, this.selectedDate.day);

    return today == selectedDate;
  }

  FoodLogFocusedDateState copyWith({
    DateTime? selectedDate,
  }) {
    return FoodLogFocusedDateState(
      selectedDate: selectedDate ?? this.selectedDate,
    );
  }
}
