import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:fit_tip/fitness_tracking/fitness_tracking.dart';
import 'package:fitness_repository/fitness_repository.dart';
import 'package:formz/formz.dart';

part 'workouts_days_list_event.dart';
part 'workouts_days_list_state.dart';

class WorkoutsDaysListBloc extends Bloc<WorkoutsDaysListEvent, WorkoutsDaysListState> {
  WorkoutsDaysListBloc({
    required AddWorkoutFormBloc addWorkoutFormBloc,
  }) : super(
          WorkoutsDaysListState(
            workoutDays: WorkoutDaysList.pure(
              workoutsPerWeekend: int.tryParse(addWorkoutFormBloc.state.daysPerWeek.value) ?? 0,
            ),
          ),
        );

  @override
  Stream<WorkoutsDaysListState> mapEventToState(
    WorkoutsDaysListEvent event,
  ) async* {
    if (event is WorkoutDaysListItemAdded) {
      yield* _mapItemAddedToState(event);
    } else if (event is WorkoutDaysListItemUpdated) {
      yield* _mapItemUpdatedToState(event);
    } else if (event is WorkoutDaysListItemRemoved) {
      yield* _mapItemRemovedToState(event);
    } else if (event is WorkoutDaysListWorkoutsPerWeekUpdated) {
      yield* _mapWorkoutsPerWeekUpdatedToState(event);
    }
  }

  Stream<WorkoutsDaysListState> _mapItemAddedToState(WorkoutDaysListItemAdded event) async* {
    final items = state.workoutDays.value;

    items.add(event.workoutDay);
    final workoutDays = WorkoutDaysList.dirty(value: items);

    yield state.copyWith(
      workoutDays: workoutDays,
      status: Formz.validate([workoutDays]),
    );
  }

  Stream<WorkoutsDaysListState> _mapItemUpdatedToState(WorkoutDaysListItemUpdated event) async* {
    List<WorkoutDay> items = state.workoutDays.value;

    items = items.map((e) {
      if (e.id == event.workoutDay.id) {
        return event.workoutDay;
      }
      return e;
    }).toList();

    final workoutDays = WorkoutDaysList.dirty(value: items, workoutsPerWeekend: state.workoutDays.workoutsPerWeekend);

    yield state.copyWith(
      workoutDays: workoutDays,
      status: Formz.validate([workoutDays]),
    );
  }

  Stream<WorkoutsDaysListState> _mapItemRemovedToState(WorkoutDaysListItemRemoved event) async* {
    List<WorkoutDay> items = state.workoutDays.value;

    items.removeWhere((element) => element.id == event.workoutDay.id);

    final workoutDaysList = WorkoutDaysList.dirty(value: items, workoutsPerWeekend: state.workoutDays.workoutsPerWeekend);

    yield state.copyWith(
      status: Formz.validate([workoutDaysList]),
      workoutDays: workoutDaysList,
    );
  }

  Stream<WorkoutsDaysListState> _mapWorkoutsPerWeekUpdatedToState(WorkoutDaysListWorkoutsPerWeekUpdated event) async* {
    final int amount = int.parse(event.workouts);
    final int currentAmount = state.workoutDays.workoutsPerWeekend;
    int diff = (amount - currentAmount).abs();
    final List<WorkoutDay> currentWorkoutDays = state.workoutDays.value;

    List<WorkoutDay> newList = const [];
    if (amount > currentAmount) {
      if (currentWorkoutDays.isEmpty) {
        newList = List.generate(diff, getPureWorkoutDay);
      } else {
        if (diff == 1) {
          newList.insert(newList.length - 1, getPureWorkoutDay(newList.length));
        } else {
          newList.insertAll(newList.length - 1, List.generate(diff, (index) => getPureWorkoutDay(index + newList.length)));
        }
      }

      final workoutDays = WorkoutDaysList.dirty(workoutsPerWeekend: amount, value: newList);
      yield state.copyWith(
        workoutDays: workoutDays,
        status: Formz.validate([workoutDays]),
      );
    } else if (amount < currentAmount) {
      newList = List.from(currentWorkoutDays);

      for (int i = 0; i < diff; i++) {
        newList.removeLast();
      }

      final workoutDays = WorkoutDaysList.dirty(workoutsPerWeekend: amount, value: newList);
      yield state.copyWith(
        workoutDays: workoutDays,
        status: Formz.validate([workoutDays]),
      );
    }
  }

  WorkoutDay getPureWorkoutDay(int index) {
    return WorkoutDay(id: index.toString(), day: index);
  }
}
