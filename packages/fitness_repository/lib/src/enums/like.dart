enum Like { up, none }

extension LikeX on Like {
  bool get isUp => this == Like.up;
  bool get isNone => this == Like.none;

  Like get opposite => isUp ? Like.none : Like.up;
}
