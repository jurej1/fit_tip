part of 'water_log_focused_day_bloc.dart';

class WaterLogFocusedDayState extends Equatable {
  final DateTime selectedDate;

  WaterLogFocusedDayState({
    required DateTime selectedDate,
  }) : this.selectedDate = DateTime(
          selectedDate.year,
          selectedDate.month,
          selectedDate.day,
        );

  bool get isSelectedDateToday {
    final today = DateTime.now();

    return selectedDate == DateTime(today.year, today.month, today.day);
  }

  factory WaterLogFocusedDayState.initial() {
    return WaterLogFocusedDayState(selectedDate: DateTime.now());
  }

  @override
  List<Object?> get props => [selectedDate];

  WaterLogFocusedDayState copyWith({
    DateTime? selectedDate,
  }) {
    return WaterLogFocusedDayState(
      selectedDate: selectedDate ?? this.selectedDate,
    );
  }
}
