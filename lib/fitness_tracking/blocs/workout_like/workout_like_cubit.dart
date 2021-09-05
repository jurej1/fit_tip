import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:fit_tip/authentication/authentication.dart';
import 'package:fitness_repository/fitness_repository.dart';

part 'workout_like_state.dart';

class WorkoutLikeCubit extends Cubit<WorkoutLikeState> {
  WorkoutLikeCubit({
    required Like like,
    required String workoutId,
    required AuthenticationBloc authenticationBloc,
    required FitnessRepository fitnessRepository,
  })  : _authenticationBloc = authenticationBloc,
        _fitnessRepository = fitnessRepository,
        _workoutId = workoutId,
        super(WorkoutLikeInitial(like));

  final FitnessRepository _fitnessRepository;
  final AuthenticationBloc _authenticationBloc;
  final String _workoutId;

  Future<void> like() async {
    if (_authenticationBloc.state.isAuthenticated) {
      final newValue = state.like.opposite;

      emit(WorkoutLikeLoading(newValue));

      try {
        await _fitnessRepository.likeWorkout(_workoutId, newValue);
        await _fitnessRepository.addLikedWorkoutId(_authenticationBloc.state.user!.uid!, _workoutId);
        emit(WorkoutLikeSuccess(newValue));
      } catch (error) {
        emit(WorkoutLikeFail(newValue.opposite));
      }
    }
  }
}
