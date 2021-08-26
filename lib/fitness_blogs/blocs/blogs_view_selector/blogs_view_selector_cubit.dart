import 'package:bloc/bloc.dart';

enum BlogsViewSelectorState {
  all,
  saved,
}

extension BlogsViewSelectorStateX on BlogsViewSelectorState {
  bool get isAll => this == BlogsViewSelectorState.all;
  bool get isSaved => this == BlogsViewSelectorState.saved;
}

class BlogsViewSelectorCubit extends Cubit<BlogsViewSelectorState> {
  BlogsViewSelectorCubit() : super(BlogsViewSelectorState.all);

  void viewUpdatedEnum(BlogsViewSelectorState value) {
    emit(value);
  }

  void viewUpdateIndex(int index) {
    emit(BlogsViewSelectorState.values.elementAt(index));
  }
}
