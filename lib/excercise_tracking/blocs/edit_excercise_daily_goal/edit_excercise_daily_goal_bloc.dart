import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:fit_tip/authentication/authentication.dart';
import 'package:fit_tip/excercise_tracking/excercise_tracking.dart';
import 'package:fit_tip/shared/blocs/blocs.dart';
import 'package:fitness_repository/fitness_repository.dart';
import 'package:formz/formz.dart';

part 'edit_excercise_daily_goal_event.dart';
part 'edit_excercise_daily_goal_state.dart';

class EditExcerciseDailyGoalBloc extends Bloc<EditExcerciseDailyGoalEvent, EditExcerciseDailyGoalState> {
  EditExcerciseDailyGoalBloc({
    required AuthenticationBloc authenticationBloc,
    required FitnessRepository fitnessRepository,
    required DaySelectorBloc daySelectorBloc,
    required ExcerciseDailyGoalBloc excerciseDailyGoalBloc,
  })  : _fitnessRepository = fitnessRepository,
        super(
          excerciseDailyGoalBloc.state is ExcerciseDailyGoalLoadSuccess
              ? EditExcerciseDailyGoalState.initial(excerciseDailyGoalBloc.state as ExcerciseDailyGoalLoadSuccess)
              : EditExcerciseDailyGoalState(date: daySelectorBloc.state.selectedDate),
        ) {
    final authState = authenticationBloc.state;
    _isAuth = authState.isAuthenticated;
    _userId = authState.user?.uid;
    _authSubcription = authenticationBloc.stream.listen((event) {
      _isAuth = event.isAuthenticated;
      _userId = event.user?.uid;
    });
  }

  final FitnessRepository _fitnessRepository;
  late final StreamSubscription _authSubcription;

  bool _isAuth = false;
  String? _userId;

  @override
  Future<void> close() {
    _authSubcription.cancel();
    return super.close();
  }

  @override
  Stream<EditExcerciseDailyGoalState> mapEventToState(
    EditExcerciseDailyGoalEvent event,
  ) async* {
    if (event is EditExcerciseDailyGoalMinutesPerDayUpdated) {
      yield* _mapMinutesPerDayUpdatedToState(event);
    } else if (event is EditExcerciseDailyGoalCaloriesBurnedPerDayUpdated) {
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

  Stream<EditExcerciseDailyGoalState> _mapCaloriesBurnedPerWeek(EditExcerciseDailyGoalCaloriesBurnedPerDayUpdated event) async* {
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
        await _fitnessRepository.addExcerciseDailyGoal(_userId!, goal);

        yield state.copyWith(status: FormzStatus.submissionSuccess);
      } catch (e) {
        yield state.copyWith(status: FormzStatus.submissionFailure);
      }
    }
  }
}
