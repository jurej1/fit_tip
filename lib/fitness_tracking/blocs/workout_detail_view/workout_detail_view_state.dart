part of 'workout_detail_view_bloc.dart';

abstract class WorkoutDetailViewState extends Equatable {
  const WorkoutDetailViewState(
    this.workout,
  );

  final Workout workout;

  BorderRadius get appBarBorderRadius => BorderRadius.only(
        bottomLeft: Radius.circular(30),
        bottomRight: Radius.circular(30),
      );

  LinearGradient get appBarLinearGradient => LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [Color(0xff2D56D0), Color(0xff79C1FE)],
        stops: [0.3, 0.8],
      );

  @override
  List<Object> get props => [workout];
}

class WorkoutDetailViewLoading extends WorkoutDetailViewState {
  const WorkoutDetailViewLoading(Workout workout) : super(workout);
}

class WorkoutDetailViewFail extends WorkoutDetailViewState {
  const WorkoutDetailViewFail(Workout workout) : super(workout);
}

class WorkoutDetailViewLoadSuccess extends WorkoutDetailViewState {
  const WorkoutDetailViewLoadSuccess(Workout workout) : super(workout);
}
