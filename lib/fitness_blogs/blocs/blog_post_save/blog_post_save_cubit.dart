import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'blog_post_save_state.dart';

class BlogPostSaveCubit extends Cubit<BlogPostSaveState> {
  BlogPostSaveCubit({
    required bool initialValue,
    required String blogId,
  }) : super(
          BlogPostSaveState(
            initialValue,
            blogId,
          ),
        );

  void buttonPressed() {
    emit(state.copyWith(isSaved: !state.isSaved));
  }
}
