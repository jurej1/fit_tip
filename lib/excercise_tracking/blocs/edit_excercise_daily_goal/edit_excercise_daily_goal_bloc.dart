import 'dart:async';

import 'package:activity_repository/activity_repository.dart';
import 'package:authentication_repository/authentication_repository.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:fit_tip/authentication/authentication.dart';
import 'package:fit_tip/excercise_tracking/blocs/blocs.dart';
import 'package:fit_tip/excercise_tracking/models/models.dart';
import 'package:fit_tip/shared/blocs/blocs.dart';
import 'package:formz/formz.dart';

part 'edit_excercise_daily_goal_event.dart';
part 'edit_excercise_daily_goal_state.dart';

class EditExcerciseDailyGoalBloc extends Bloc<EditExcerciseDailyGoalEvent, EditExcerciseDailyGoalState> {
  EditExcerciseDailyGoalBloc({
    required AuthenticationBloc authenticationBloc,
    required ActivityRepository activityRepository,
    required DaySelectorBloc daySelectorBloc,
  })  : _authenticationBloc = authenticationBloc,
        _activityRepository = activityRepository,
        _daySelectorBloc = daySelectorBloc,
        super(EditExcerciseDailyGoalState(date: daySelectorBloc.state.selectedDate));

  final AuthenticationBloc _authenticationBloc;
  final ActivityRepository _activityRepository;
  final DaySelectorBloc _daySelectorBloc;

  bool get _isAuth => _authenticationBloc.state.isAuthenticated;
  User? get _user => _authenticationBloc.state.user;

  @override
  Stream<EditExcerciseDailyGoalState> mapEventToState(
    EditExcerciseDailyGoalEvent event,
  ) async* {
    if (event is EditExcerciseDailyGoalMinutesPerDayUpdated) {
      yield* _mapMinutesPerDayUpdatedToState(event);
    } else if (event is EditExcerciseDailyGoalCaloriesBurnedPerWeekUpdated) {
      yield* _mapCaloriesBurnedPerWeek(event);
    } else if (event is EditExcerciseDailyGoalMinutesPerWorkoutUpdated) {
      yield* _mapMinutesPerWorkoutUpdatedToState(event);
    } else if (event is EditExcerciseDailyGoalWorkoutsPerWeekUpdated) {
      yield* _mapWorkoutsPerWeekUpdatedToState(event);
    } else if (event is EditExcerciseDailyGoalFormSubmited) {
      yield* _mapFormSubmitedToState();
    }
  }

  Stream<EditExcerciseDailyGoalState> _mapMinutesPerDayUpdatedToState(EditExcerciseDailyGoalMinutesPerDayUpdated event) async* {
    final minutesPerDay = ExcerciseCalories.dirty(event.value);

    yield state.copyWith(
      minutesPerDay: minutesPerDay,
      status: Formz.validate(
        [
          minutesPerDay,
          state.caloriesBurnedPerDay,
          state.minutesPerWorkout,
          state.workoutsPerWeek,
        ],
      ),
    );
  }

  Stream<EditExcerciseDailyGoalState> _mapCaloriesBurnedPerWeek(EditExcerciseDailyGoalCaloriesBurnedPerWeekUpdated event) async* {
    final caloriesBurnedPerDay = ExcerciseCalories.dirty(event.value);

    yield state.copyWith(
      caloriesBurnedPerDay: caloriesBurnedPerDay,
      status: Formz.validate([
        caloriesBurnedPerDay,
        state.minutesPerDay,
        state.minutesPerWorkout,
        state.workoutsPerWeek,
      ]),
    );
  }

  Stream<EditExcerciseDailyGoalState> _mapMinutesPerWorkoutUpdatedToState(EditExcerciseDailyGoalMinutesPerWorkoutUpdated event) async* {
    final minutesPerWorkout = ExcerciseCalories.dirty(event.value);

    yield state.copyWith(
      minutesPerWorkout: minutesPerWorkout,
      status: Formz.validate([
        minutesPerWorkout,
        state.caloriesBurnedPerDay,
        state.minutesPerDay,
        state.workoutsPerWeek,
      ]),
    );
  }

  Stream<EditExcerciseDailyGoalState> _mapWorkoutsPerWeekUpdatedToState(EditExcerciseDailyGoalWorkoutsPerWeekUpdated event) async* {
    final workoutsPerWeek = ExcerciseCalories.dirty(event.value);

    yield state.copyWith(
      workoutsPerWeek: workoutsPerWeek,
      status: Formz.validate([
        workoutsPerWeek,
        state.caloriesBurnedPerDay,
        state.minutesPerDay,
        state.minutesPerWorkout,
      ]),
    );
  }

  Stream<EditExcerciseDailyGoalState> _mapFormSubmitedToState() async* {
    final workoutsPerWeek = ExcerciseCalories.dirty(state.workoutsPerWeek.value);
    final minutesPerWorkout = ExcerciseCalories.dirty(state.minutesPerWorkout.value);
    final caloriesBurnedPerDay = ExcerciseCalories.dirty(state.caloriesBurnedPerDay.value);
    final minutesPerDay = ExcerciseCalories.dirty(state.minutesPerDay.value);

    yield state.copyWith(
      minutesPerDay: minutesPerDay,
      caloriesBurnedPerDay: caloriesBurnedPerDay,
      minutesPerWorkout: minutesPerWorkout,
      workoutsPerWeek: workoutsPerWeek,
      status: Formz.validate([minutesPerDay, caloriesBurnedPerDay, minutesPerWorkout, workoutsPerWeek]),
    );

    if (state.status.isValidated && _isAuth) {
      yield state.copyWith(status: FormzStatus.submissionInProgress);

      try {
        ExcerciseDailyGoal goal = state.goal();
        await _activityRepository.addExcerciseDailyGoal(_user!.id!, goal);

        yield state.copyWith(status: FormzStatus.submissionSuccess);
      } catch (e) {
        yield state.copyWith(status: FormzStatus.submissionFailure);
      }
    }
  }
}
