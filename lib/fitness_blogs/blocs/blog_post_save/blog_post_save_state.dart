part of 'blog_post_save_cubit.dart';

class BlogPostSaveState extends Equatable {
  final bool isSaved;

  const BlogPostSaveState(
    this.isSaved,
  );

  @override
  List<Object?> get props => [isSaved];

  BlogPostSaveState copyWith({
    bool? isSaved,
  }) {
    return BlogPostSaveState(
      isSaved ?? this.isSaved,
    );
  }
}
