import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';

enum BlogsViewSelectorState {
  all,
  saved,
}

extension BlogsViewSelectorStateX on BlogsViewSelectorState {
  bool get isAll => this == BlogsViewSelectorState.all;
  bool get isSaved => this == BlogsViewSelectorState.saved;

  IconData toIcon() {
    if (isAll) {
      return Icons.list;
    } else {
      return Icons.bookmark;
    }
  }

  String toBottomNavigationString() {
    if (isAll) {
      return 'All';
    } else {
      return 'Saved';
    }
  }
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
