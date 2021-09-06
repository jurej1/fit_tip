import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fit_tip/authentication/authentication.dart';
import 'package:fit_tip/fitness_tracking/blocs/blocs.dart';
import 'package:fitness_repository/fitness_repository.dart';

class UserWorkoutsListBloc extends WorkoutInfosBaseBloc {
  UserWorkoutsListBloc({
    required AuthenticationBloc authenticationBloc,
    required FitnessRepository fitnessRepository,
  })  : _authenticationBloc = authenticationBloc,
        _fitnessRepository = fitnessRepository,
        super(initialState: WorkoutInfosLoading());

  final AuthenticationBloc _authenticationBloc;
  final FitnessRepository _fitnessRepository;

  final int _limit = 12;
  DocumentSnapshot? _lastFetchDocument;

  @override
  Stream<WorkoutInfosBaseState> mapLoadRequestedToState(WorkoutInfosLoadRequested event) async* {
    if (_authenticationBloc.state.isAuthenticated) {
      yield WorkoutInfosLoading();

      try {
        QuerySnapshot querySnapshot = await _fitnessRepository.getWorkoutInfosByUserId(
          _authenticationBloc.state.user!.uid!,
          isAuthUserData: true,
          limit: _limit,
        );

        if (querySnapshot.docs.isEmpty) {
          yield WorkoutInfosLoadSuccess([], true);
        } else {
          _lastFetchDocument = querySnapshot.docs.last;

          List<WorkoutInfo> infos = _mapQuerySnapshotToList(querySnapshot);

          yield WorkoutInfosLoadSuccess(infos, querySnapshot.docs.length < _limit);
        }
      } catch (error) {
        yield WorkoutInfosFail();
      }
    } else {
      yield WorkoutInfosFail();
    }
  }

  @override
  Stream<WorkoutInfosBaseState> mapLoadMoreRequestedToState(WorkoutInfosLoadMoreRequested event) async* {
    if (state is WorkoutInfosLoadSuccess) {
      final oldState = state as WorkoutInfosLoadSuccess;

      try {
        QuerySnapshot querySnapshot = await _fitnessRepository.getWorkoutInfosByUserId(
          _authenticationBloc.state.user!.uid!,
          isAuthUserData: true,
          limit: _limit,
          startAfterDocument: _lastFetchDocument,
        );

        if (querySnapshot.docs.isEmpty) {
          yield WorkoutInfosLoadSuccess(oldState.infos, true);
        } else {
          _lastFetchDocument = querySnapshot.docs.last;

          List<WorkoutInfo> newInfos = _mapQuerySnapshotToList(querySnapshot);
          yield WorkoutInfosLoadSuccess(oldState.infos + newInfos, querySnapshot.docs.length < _limit);
        }
      } catch (error) {
        yield WorkoutInfosFail();
      }
    }
  }

  List<WorkoutInfo> _mapQuerySnapshotToList(QuerySnapshot querySnapshot) {
    if (_authenticationBloc.state.isAuthenticated) {
      final String uid = _authenticationBloc.state.user!.uid!;
      return WorkoutInfo.fromQuerySnapshot(
        querySnapshot,
        activeWorkoutId: _fitnessRepository.getActiveWorkoutId(uid),
        authUserId: uid,
        likedWorkoutids: _fitnessRepository.getLikedWorkoutIds(uid),
        savedWorkoutIds: _fitnessRepository.getSavedWorkoutIds(uid),
      );
    }

    return WorkoutInfo.fromQuerySnapshot(querySnapshot);
  }
}
