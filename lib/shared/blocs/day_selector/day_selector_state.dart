part of 'day_selector_bloc.dart';

class DaySelectorState extends Equatable {
  const DaySelectorState(
    this.selectedDate,
  );

  final DateTime selectedDate;

  bool isSelectedDayToday() {
    final selected = DateTime(selectedDate.year, selectedDate.month, selectedDate.day);

    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);

    return selected == today;
  }

  @override
  List<Object> get props => [selectedDate];

  DaySelectorState copyWith({
    DateTime? selectedDate,
  }) {
    return DaySelectorState(
      selectedDate ?? this.selectedDate,
    );
  }
}
