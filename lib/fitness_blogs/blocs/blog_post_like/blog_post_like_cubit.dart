import 'package:bloc/bloc.dart';
import 'package:blog_repository/blog_repository.dart';
import 'package:equatable/equatable.dart';

part 'blog_post_like_state.dart';

class BlogPostLikeCubit extends Cubit<BlogPostLikeState> {
  BlogPostLikeCubit({
    required Like initialValue,
    required String blogId,
    required BlogRepository blogRepository,
  })  : _blogRepository = blogRepository,
        _blogId = blogId,
        super(BlogPostLikeInitial(initialValue));

  final BlogRepository _blogRepository;

  final String _blogId;

  Future<void> buttonPressed() async {
    final oldStateLike = state.like;

    emit(BlogPostLikeLoading(oldStateLike.opposite));

    try {
      await _blogRepository.likeBlogPost(_blogId, state.like);
      emit(BlogPostLikeSuccess(state.like));
    } catch (error) {
      emit(BlogPostLikeFail(oldStateLike));
    }
  }
}
