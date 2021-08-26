part of 'blog_post_save_cubit.dart';

class BlogPostSaveState extends Equatable {
  final bool isSaved;
  final String blocId;

  const BlogPostSaveState(this.isSaved, this.blocId);

  @override
  List<Object?> get props => [isSaved, blocId];

  BlogPostSaveState copyWith({
    bool? isSaved,
    String? blocId,
  }) {
    return BlogPostSaveState(
      isSaved ?? this.isSaved,
      blocId ?? this.blocId,
    );
  }
}
