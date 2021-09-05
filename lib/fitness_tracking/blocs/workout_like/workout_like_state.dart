part of 'workout_like_cubit.dart';

abstract class WorkoutLikeState extends Equatable {
  const WorkoutLikeState(this.like);

  final Like like;

  @override
  List<Object> get props => [like];
}

class WorkoutLikeInitial extends WorkoutLikeState {
  const WorkoutLikeInitial(Like like) : super(like);
}

class WorkoutLikeLoading extends WorkoutLikeState {
  const WorkoutLikeLoading(Like like) : super(like);
}

class WorkoutLikeSuccess extends WorkoutLikeState {
  const WorkoutLikeSuccess(Like like) : super(like);
}

class WorkoutLikeFail extends WorkoutLikeState {
  const WorkoutLikeFail(Like like) : super(like);
}
