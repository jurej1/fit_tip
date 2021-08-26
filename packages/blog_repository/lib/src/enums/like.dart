enum Like { yes, no }

extension LikeX on Like {
  bool get isYes => this == Like.yes;
  bool get isNo => this == Like.no;
}
