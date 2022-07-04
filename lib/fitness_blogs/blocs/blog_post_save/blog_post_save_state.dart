part of 'blog_post_save_cubit.dart';

abstract class BlogPostSaveState extends Equatable {
  final bool isSaved;

  const BlogPostSaveState(
    this.isSaved,
  );

  @override
  List<Object?> get props => [isSaved];
}

class BlogPostSaveInitial extends BlogPostSaveState {
  const BlogPostSaveInitial(bool isSaved) : super(isSaved);
}

class BlogPostSaveLoading extends BlogPostSaveState {
  const BlogPostSaveLoading(bool isSaved) : super(isSaved);
}

class BlogPostSaveLoadSuccess extends BlogPostSaveState {
  const BlogPostSaveLoadSuccess(bool isSaved) : super(isSaved);
}

class BlogPostSaveFail extends BlogPostSaveState {
  const BlogPostSaveFail(bool isSaved) : super(isSaved);
}
