part of 'add_blog_post_bloc.dart';

abstract class AddBlogPostEvent extends Equatable {
  const AddBlogPostEvent();

  @override
  List<Object?> get props => [];
}

class _AddBlogPostUserUpdated extends AddBlogPostEvent {
  final User? value;

  const _AddBlogPostUserUpdated(this.value);

  @override
  List<Object?> get props => [value];
}

class AddBlogPostTitleUpdated extends AddBlogPostEvent {
  final String value;

  const AddBlogPostTitleUpdated(this.value);

  @override
  List<Object> get props => [value];
}

class AddBlogPostContentUpdated extends AddBlogPostEvent {
  final String value;

  const AddBlogPostContentUpdated(this.value);

  @override
  List<Object> get props => [value];
}

class AddBlogPostBannerUpdated extends AddBlogPostEvent {
  final XFile? value;

  const AddBlogPostBannerUpdated(this.value);

  @override
  List<Object?> get props => [value];
}

class AddBlogPostTagAdded extends AddBlogPostEvent {}

class AddBlogPostTagRemoved extends AddBlogPostEvent {
  final String value;

  const AddBlogPostTagRemoved(this.value);

  @override
  List<Object> get props => [value];
}

class AddBlogPostPublicPressed extends AddBlogPostEvent {}

class AddBlogPostTagFieldUpdated extends AddBlogPostEvent {
  final String value;

  const AddBlogPostTagFieldUpdated(this.value);

  @override
  List<Object> get props => [value];
}

class AddBlogPostSubmit extends AddBlogPostEvent {}
