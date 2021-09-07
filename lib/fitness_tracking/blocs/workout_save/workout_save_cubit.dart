import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:fit_tip/authentication/authentication.dart';
import 'package:fitness_repository/fitness_repository.dart';

part 'workout_save_state.dart';

class WorkoutSaveCubit extends Cubit<WorkoutSaveState> {
  WorkoutSaveCubit({
    required bool isSaved,
    required String workoutId,
    required FitnessRepository fitnessRepository,
    required AuthenticationBloc authenticationBloc,
  })  : _fitnessRepository = fitnessRepository,
        _workoutId = workoutId,
        _authenticationBloc = authenticationBloc,
        super(WorkoutSaveInitial(isSaved));

  final FitnessRepository _fitnessRepository;
  final AuthenticationBloc _authenticationBloc;

  final String _workoutId;

  void save() {
    if (_authenticationBloc.state.isAuthenticated) {
      bool newValue = !state.isSaved;
      emit(WorkoutSaveLoading(newValue));
      try {
        if (newValue == true) {
          _fitnessRepository.addSavedWorkoutId(_authenticationBloc.state.user!.uid!, _workoutId);
        } else if (newValue == false) {
          _fitnessRepository.removeSavedWorkoutId(_authenticationBloc.state.user!.uid!, _workoutId);
        }

        emit(WorkoutSaveLoadSuccess(newValue));
      } catch (error) {
        emit(WorkoutsSaveFail(!newValue));
      }
    }
  }
}
