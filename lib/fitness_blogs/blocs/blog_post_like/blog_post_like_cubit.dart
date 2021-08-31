import 'package:bloc/bloc.dart';
import 'package:blog_repository/blog_repository.dart';
import 'package:equatable/equatable.dart';

part 'blog_post_like_state.dart';

class BlogPostLikeCubit extends Cubit<BlogPostLikeState> {
  BlogPostLikeCubit({
    required Like initialValue,
    required int likesAmount,
    required String blogId,
    required BlogRepository blogRepository,
  })  : _blogRepository = blogRepository,
        super(BlogPostLikeInitial(initialValue, likesAmount, blogId));

  final BlogRepository _blogRepository;

  Future<void> buttonPressed() async {
    final Like oldStateLike = state.like;
    final Like oppositeValue = oldStateLike.opposite;

    final int oldAmount = state.likesAmount;
    final int newAmount = oppositeValue.isYes ? oldAmount + 1 : oldAmount - 1;

    emit(BlogPostLikeLoading(oppositeValue, newAmount, state.blogId));

    try {
      await _blogRepository.likeBlogPost(state.blogId, state.like);
      emit(BlogPostLikeSuccess(state.like, newAmount, state.blogId));
    } catch (error) {
      emit(BlogPostLikeFail(oldStateLike, oldAmount, state.blogId));
    }
  }
}
