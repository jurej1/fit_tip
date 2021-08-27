import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../fitness_blogs.dart';

class BlogsViewSelector extends StatelessWidget {
  const BlogsViewSelector({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<BlogsViewSelectorCubit, BlogsViewSelectorState>(
      builder: (context, state) {
        return BottomNavigationBar(
          currentIndex: BlogsViewSelectorState.values.indexOf(state),
          items: BlogsViewSelectorState.values.map(
            (e) {
              return BottomNavigationBarItem(
                icon: Icon(e.toIcon()),
                label: e.toBottomNavigationString(),
              );
            },
          ).toList(),
          onTap: (index) {
            BlocProvider.of<BlogsViewSelectorCubit>(context).viewUpdateIndex(index);
          },
        );
      },
    );
  }
}
