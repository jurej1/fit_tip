part of 'add_blog_post_bloc.dart';

class AddBlogPostState extends Equatable {
  const AddBlogPostState({
    this.status = FormzStatus.pure,
    this.title = const BlogTitle.pure(),
    this.content = const BlogContent.pure(),
    this.banner = const BlogBanner.pure(),
    this.tags = const BlogTags.pure(),
    required this.user,
  });

  final FormzStatus status;
  final BlogTitle title;
  final BlogContent content;
  final BlogBanner banner;
  final BlogTags tags;
  final User user;

  @override
  List<Object?> get props {
    return [
      status,
      title,
      content,
      banner,
      tags,
      user,
    ];
  }

  AddBlogPostState copyWith({
    FormzStatus? status,
    BlogTitle? title,
    BlogContent? content,
    BlogBanner? banner,
    BlogTags? tags,
    User? user,
  }) {
    return AddBlogPostState(
      status: status ?? this.status,
      title: title ?? this.title,
      content: content ?? this.content,
      banner: banner ?? this.banner,
      tags: tags ?? this.tags,
      user: user ?? this.user,
    );
  }
}
