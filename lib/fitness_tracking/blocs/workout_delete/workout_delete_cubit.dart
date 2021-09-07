import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:fit_tip/authentication/authentication.dart';
import 'package:fitness_repository/fitness_repository.dart';

part 'workout_delete_state.dart';

class WorkoutDeleteCubit extends Cubit<WorkoutDeleteState> {
  WorkoutDeleteCubit({
    required AuthenticationBloc authenticationBloc,
    required FitnessRepository fitnessRepository,
    required WorkoutInfo workoutInfo,
  })  : _fitnessRepository = fitnessRepository,
        _authenticationBloc = authenticationBloc,
        _workoutInfo = workoutInfo,
        super(WorkoutDeleteInitial(authenticationBloc.state.user?.uid == workoutInfo.uid));

  final FitnessRepository _fitnessRepository;
  final AuthenticationBloc _authenticationBloc;
  final WorkoutInfo _workoutInfo;

  bool get _canDelete {
    return _authenticationBloc.state.user?.uid == _workoutInfo.uid;
  }

  Future<void> deleteRequested() async {
    if (_canDelete) {
      emit(WorkoutDeleteLoading(_canDelete));
      await _fitnessRepository.deleteWorkoutById(_workoutInfo.id);
      emit(WorkoutDeleteLoadSuccess(_canDelete));
    } else {
      emit(WorkoutDeleteFail(_canDelete));
    }
  }
}
