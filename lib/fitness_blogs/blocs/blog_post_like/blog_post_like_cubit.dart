import 'package:bloc/bloc.dart';
import 'package:blog_repository/blog_repository.dart';
import 'package:equatable/equatable.dart';
import 'package:fit_tip/authentication/authentication.dart';

part 'blog_post_like_state.dart';

class BlogPostLikeCubit extends Cubit<BlogPostLikeState> {
  BlogPostLikeCubit({
    required Like initialValue,
    required int likesAmount,
    required String blogId,
    required BlogRepository blogRepository,
    required AuthenticationBloc authenticationBloc,
  })  : _blogRepository = blogRepository,
        _authenticationBloc = authenticationBloc,
        _blogId = blogId,
        super(BlogPostLikeInitial(initialValue, likesAmount));

  final BlogRepository _blogRepository;
  final AuthenticationBloc _authenticationBloc;
  final String _blogId;

  Future<void> buttonPressed() async {
    if (_authenticationBloc.state.isAuthenticated) {
      final Like oldStateLike = state.like;
      final Like oppositeValue = oldStateLike.opposite;

      final int oldAmount = state.likesAmount;
      final int newAmount = oppositeValue.isYes ? oldAmount + 1 : oldAmount - 1;

      emit(BlogPostLikeLoading(oppositeValue, newAmount));

      try {
        await _blogRepository.likeBlogPost(_blogId, state.like);
        String uid = _authenticationBloc.state.user!.uid!;
        if (state.like.isYes) {
          await _blogRepository.addLikedBlogId(uid, _blogId);
        }

        if (state.like.isNo) {
          await _blogRepository.removeLikedBlogId(uid, _blogId);
        }

        emit(BlogPostLikeSuccess(state.like, newAmount));
      } catch (error) {
        emit(BlogPostLikeFail(oldStateLike, oldAmount));
      }
    }
  }
}
