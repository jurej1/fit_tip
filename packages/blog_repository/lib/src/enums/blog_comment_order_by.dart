enum BlogCommentOrderBy {
  likesAscending,
  likesDescending,
  createdDescending,
  createdAscending,
  likesAndCreatedDescending,
}

extension BlogCommentOrderByX on BlogCommentOrderBy {
  bool get isLikesDescending => this == BlogCommentOrderBy.likesDescending;
  bool get isLikesAscending => this == BlogCommentOrderBy.likesAscending;
  bool get isCreatedAscending => this == BlogCommentOrderBy.createdAscending;
  bool get isCreatedDescending => this == BlogCommentOrderBy.createdDescending;
  bool get isLikesAndCreatedDescending => this == BlogCommentOrderBy.likesAndCreatedDescending;
}
