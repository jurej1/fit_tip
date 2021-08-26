import 'package:bloc/bloc.dart';
import 'package:blog_repository/blog_repository.dart';

class BlogPostLikeCubit extends Cubit<Like> {
  BlogPostLikeCubit() : super(Like.no);
}
