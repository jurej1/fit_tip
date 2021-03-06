import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';

enum BlogsViewSelectorState {
  all,
  saved,
  user,
}

extension BlogsViewSelectorStateX on BlogsViewSelectorState {
  bool get isAll => this == BlogsViewSelectorState.all;
  bool get isSaved => this == BlogsViewSelectorState.saved;
  bool get isUsers => this == BlogsViewSelectorState.user;

  IconData toIcon() {
    if (isAll) {
      return Icons.list;
    } else if (isSaved) {
      return Icons.bookmark;
    } else {
      return Icons.person;
    }
  }

  String toBottomNavigationString() {
    if (isAll) {
      return 'All';
    } else if (isSaved) {
      return 'Saved';
    } else {
      return 'Your';
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
