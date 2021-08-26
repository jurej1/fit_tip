part of 'saved_blog_posts_bloc.dart';

class SavedBlogPostsState extends Equatable {
  const SavedBlogPostsState([this.blogIds = const []]);

  final List<String> blogIds;

  @override
  List<Object> get props => [blogIds];

  SavedBlogPostsState copyWith({
    List<String>? blogIds,
  }) {
    return SavedBlogPostsState(
      blogIds ?? this.blogIds,
    );
  }
}
