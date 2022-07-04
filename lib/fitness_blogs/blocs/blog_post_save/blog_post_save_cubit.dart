import 'package:bloc/bloc.dart';
import 'package:blog_repository/blog_repository.dart';
import 'package:equatable/equatable.dart';
import 'package:fit_tip/authentication/authentication.dart';

part 'blog_post_save_state.dart';

class BlogPostSaveCubit extends Cubit<BlogPostSaveState> {
  BlogPostSaveCubit({
    required String blogId,
    required AuthenticationBloc authenticationBloc,
    required BlogRepository blogRepository,
    required bool initialValue,
  })  : _blogId = blogId,
        _blogRepository = blogRepository,
        _authenticationBloc = authenticationBloc,
        super(BlogPostSaveInitial(initialValue));

  final String _blogId;
  final AuthenticationBloc _authenticationBloc;
  final BlogRepository _blogRepository;

  Future<void> buttonPressed() async {
    if (_authenticationBloc.state.isAuthenticated) {
      final newValue = !state.isSaved;

      emit(BlogPostSaveLoading(newValue));

      try {
        String uid = _authenticationBloc.state.user!.uid!;

        if (newValue == true) {
          await _blogRepository.addSavedBlogId(uid, _blogId);
        }

        if (newValue == false) {
          await _blogRepository.removedSavedBlogId(uid, _blogId);
        }

        emit(BlogPostSaveLoadSuccess(newValue));
      } catch (error) {
        emit(BlogPostSaveFail(!newValue));
      }
    }
  }
}
