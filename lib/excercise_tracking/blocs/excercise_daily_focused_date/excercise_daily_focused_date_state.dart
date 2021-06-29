part of 'excercise_daily_focused_date_bloc.dart';

class ExcerciseDailyFocusedDateState extends Equatable {
  const ExcerciseDailyFocusedDateState(
    this.selectedDate,
  );

  final DateTime selectedDate;

  bool isSelectedDateToday() {
    final selected = DateTime(selectedDate.year, selectedDate.month, selectedDate.day);
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);

    return today == selected;
  }

  @override
  List<Object> get props => [selectedDate];

  ExcerciseDailyFocusedDateState copyWith({
    DateTime? selectedDate,
  }) {
    return ExcerciseDailyFocusedDateState(
      selectedDate ?? this.selectedDate,
    );
  }
}
