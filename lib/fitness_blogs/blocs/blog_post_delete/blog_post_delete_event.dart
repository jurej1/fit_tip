part of 'blog_post_delete_bloc.dart';

abstract class BlogPostDeleteEvent extends Equatable {
  const BlogPostDeleteEvent();

  @override
  List<Object> get props => [];
}

class BlogPostDeleteRequested extends BlogPostDeleteEvent {}
