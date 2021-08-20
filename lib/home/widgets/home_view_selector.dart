import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../home.dart';

class HomeViewSelector extends StatelessWidget {
  const HomeViewSelector({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeViewSelectorCubit, HomeViewSelectorState>(
      builder: (context, state) {
        return BottomNavigationBar(
          currentIndex: HomeViewSelectorState.values.indexOf(state),
          showSelectedLabels: false,
          showUnselectedLabels: false,
          selectedItemColor: Colors.blue,
          unselectedItemColor: Colors.grey,
          items: HomeViewSelectorState.values
              .map(
                (e) => BottomNavigationBarItem(
                  icon: Icon(BlocProvider.of<HomeViewSelectorCubit>(context).mapStateToIcon(e)),
                  label: '',
                ),
              )
              .toList(),
          onTap: (index) {
            BlocProvider.of<HomeViewSelectorCubit>(context).valuUpdatedIndex(index);
          },
        );
      },
    );
  }
}
