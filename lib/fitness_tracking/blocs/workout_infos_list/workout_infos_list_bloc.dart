import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fit_tip/authentication/authentication.dart';
import 'package:fit_tip/fitness_tracking/blocs/blocs.dart';
import 'package:fitness_repository/fitness_repository.dart';

class WorkoutInfosListBloc extends WorkoutInfosBaseBloc {
  WorkoutInfosListBloc({
    required AuthenticationBloc authenticationBloc,
    required FitnessRepository fitnessRepository,
  })  : _fitnessRepository = fitnessRepository,
        super(
          initialState: WorkoutInfosLoading(),
          authenticationBloc: authenticationBloc,
          fitnessRepository: fitnessRepository,
        );

  final FitnessRepository _fitnessRepository;

  DocumentSnapshot? _lastFetchedDocument;
  final int _limit = 12;

  @override
  Stream<WorkoutInfosBaseState> mapLoadMoreRequestedToState(WorkoutInfosLoadMoreRequested event) async* {
    yield WorkoutInfosLoading();

    try {
      QuerySnapshot querySnapshot = await _fitnessRepository.getWorkoutInfosByCreated(limit: _limit);

      if (querySnapshot.docs.isEmpty) {
        yield WorkoutInfosLoadSuccess([], true);
      } else {
        _lastFetchedDocument = querySnapshot.docs.last;

        List<WorkoutInfo> infos = mapQuerySnapshotToList(querySnapshot);

        yield WorkoutInfosLoadSuccess(infos, querySnapshot.docs.length < _limit);
      }
    } catch (error) {
      yield WorkoutInfosFail();
    }
  }

  @override
  Stream<WorkoutInfosBaseState> mapLoadRequestedToState(WorkoutInfosLoadRequested event) async* {
    if (state is WorkoutInfosLoadSuccess) {
      final oldState = state as WorkoutInfosLoadSuccess;

      if (oldState.hasReachedMax == false) {
        try {
          QuerySnapshot querySnapshot = await _fitnessRepository.getWorkoutInfosByCreated(
            limit: _limit,
            startAfterDocument: _lastFetchedDocument,
          );

          if (querySnapshot.docs.isEmpty) {
            yield WorkoutInfosLoadSuccess(oldState.infos, true);
          } else {
            _lastFetchedDocument = querySnapshot.docs.last;

            List<WorkoutInfo> newInfos = mapQuerySnapshotToList(querySnapshot);

            yield WorkoutInfosLoadSuccess(oldState.infos + newInfos, querySnapshot.docs.length < _limit);
          }
        } catch (error) {
          yield WorkoutInfosFail();
        }
      }
    }
  }
}
