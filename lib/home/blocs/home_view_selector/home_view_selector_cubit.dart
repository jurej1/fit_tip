import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';

enum HomeViewSelectorState { excercise, food, water, weight }

extension HomeViewSelectorStateX on HomeViewSelectorState {
  bool get isExcercise => this == HomeViewSelectorState.excercise;
  bool get isFood => this == HomeViewSelectorState.food;
  bool get isWater => this == HomeViewSelectorState.water;
  bool get isWeight => this == HomeViewSelectorState.weight;
}

class HomeViewSelectorCubit extends Cubit<HomeViewSelectorState> {
  HomeViewSelectorCubit() : super(HomeViewSelectorState.excercise);

  void valueUpdatedEnum(HomeViewSelectorState val) {
    emit(val);
  }

  void valuUpdatedIndex(int index) {
    emit(HomeViewSelectorState.values.elementAt(index));
  }

  IconData mapStateToIcon(HomeViewSelectorState value) {
    if (value.isExcercise) {
      return Icons.sports;
    } else if (value.isFood) {
      return Icons.food_bank;
    } else if (value.isWater) {
      return Icons.water;
    } else if (value.isWeight) {
      return Icons.line_weight;
    }

    return Icons.check;
  }
}
