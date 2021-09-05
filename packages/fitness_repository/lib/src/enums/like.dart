enum Like { up, down }

extension LikeX on Like {
  bool get isUp => this == Like.up;
  bool get isDown => this == Like.down;
}
