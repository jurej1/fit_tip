enum Like { yes, no }

extension LikeX on Like {
  bool get isYes => this == Like.yes;
  bool get isNo => this == Like.no;
  Like get opposite => this.isYes ? Like.no : Like.yes;
}
