import 'package:bloc/bloc.dart';

enum BlogsViewAppBarState {
  info,
  search,
}

extension BlogsViewAppBarStateX on BlogsViewAppBarState {
  bool get isInfo => this == BlogsViewAppBarState.info;
  bool get isSearch => this == BlogsViewAppBarState.search;
}

class BlogsViewAppBarCubit extends Cubit<BlogsViewAppBarState> {
  BlogsViewAppBarCubit() : super(BlogsViewAppBarState.info);

  void searchIconButtonPressed() {
    emit(BlogsViewAppBarState.search);
  }
}
