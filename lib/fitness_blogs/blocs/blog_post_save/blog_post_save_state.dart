part of 'blog_post_save_cubit.dart';

class BlogPostSaveState extends Equatable {
  final bool value;
  final String blocId;

  const BlogPostSaveState(this.value, this.blocId);

  @override
  List<Object?> get props => [value, blocId];

  BlogPostSaveState copyWith({
    bool? value,
    String? blocId,
  }) {
    return BlogPostSaveState(
      value ?? this.value,
      blocId ?? this.blocId,
    );
  }
}
