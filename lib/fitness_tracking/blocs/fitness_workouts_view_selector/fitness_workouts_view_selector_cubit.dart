import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';

enum FitnessWorkoutsViewSelectorState {
  all,
  user,
}

extension FitnessWorkoutsViewSelectorStateX on FitnessWorkoutsViewSelectorState {
  bool get isAll => this == FitnessWorkoutsViewSelectorState.all;
  bool get isUser => this == FitnessWorkoutsViewSelectorState.user;

  String toStringReadable() {
    if (isAll) {
      return 'All';
    } else if (isUser) {
      return 'User';
    }
    return '';
  }

  IconData toIconData() {
    if (isAll) {
      return Icons.list;
    } else if (isUser) {
      return Icons.person;
    }

    return Icons.list;
  }
}

class FitnessWorkoutsViewSelectorCubit extends Cubit<FitnessWorkoutsViewSelectorState> {
  FitnessWorkoutsViewSelectorCubit() : super(FitnessWorkoutsViewSelectorState.all);

  void viewUpdatedEnum(FitnessWorkoutsViewSelectorState value) {
    emit(value);
  }

  void viewUpdatedIndex(int index) {
    emit(FitnessWorkoutsViewSelectorState.values.elementAt(index));
  }
}
