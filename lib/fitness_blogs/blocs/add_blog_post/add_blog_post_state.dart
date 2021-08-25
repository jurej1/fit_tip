part of 'add_blog_post_bloc.dart';

class AddBlogPostState {
  const AddBlogPostState({
    this.status = FormzStatus.pure,
    this.title = const BlogTitle.pure(),
    this.content = const BlogContent.pure(),
    this.banner = const BlogBanner.pure(),
    this.tags = const BlogTags.pure(),
    this.userId,
    this.author = const BlogAuthor.pure(),
    this.isPublic = true,
    this.blogPost,
    this.tagField = const BlogTag.pure(),
  });

  final FormzStatus status;
  final BlogTitle title;
  final BlogContent content;
  final BlogBanner banner;
  final BlogTags tags;
  final BlogAuthor author;
  final String? userId;
  final bool isPublic;
  final BlogPost? blogPost;
  final BlogTag tagField;

  AddBlogPostState copyWith({
    FormzStatus? status,
    BlogTitle? title,
    BlogContent? content,
    BlogBanner? banner,
    BlogTags? tags,
    BlogAuthor? author,
    String? userId,
    bool? isPublic,
    BlogPost? blogPost,
    BlogTag? tagField,
  }) {
    return AddBlogPostState(
      status: status ?? this.status,
      title: title ?? this.title,
      content: content ?? this.content,
      banner: banner ?? this.banner,
      tags: tags ?? this.tags,
      author: author ?? this.author,
      userId: userId ?? this.userId,
      isPublic: isPublic ?? this.isPublic,
      blogPost: blogPost ?? this.blogPost,
      tagField: tagField ?? this.tagField,
    );
  }

  factory AddBlogPostState.initial(User? user) {
    final author = BlogAuthor.dirty(user?.displayName);
    return AddBlogPostState(
      userId: user?.id,
      author: author,
      status: Formz.validate([author]),
    );
  }
}
