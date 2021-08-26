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
        _blogId = blogId,
        super(BlogPostLikeInitial(initialValue, likesAmount));

  final BlogRepository _blogRepository;

  final String _blogId;

  Future<void> buttonPressed() async {
    final Like oldStateLike = state.like;
    final Like oppositeValue = oldStateLike.opposite;

    final int oldAmount = state.likesAmount;
    final int newAmount = oppositeValue.isYes ? oldAmount + 1 : oldAmount - 1;

    emit(BlogPostLikeLoading(oppositeValue, newAmount));

    try {
      await _blogRepository.likeBlogPost(_blogId, state.like);
      emit(BlogPostLikeSuccess(state.like, newAmount));
    } catch (error) {
      emit(BlogPostLikeFail(oldStateLike, oldAmount));
    }
  }
}
