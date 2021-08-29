import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../fitness_blogs.dart';

class BlogsViewAppBar extends StatelessWidget with PreferredSizeWidget {
  const BlogsViewAppBar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => BlogsViewAppBarCubit(),
      child: Builder(
        builder: (context) {
          return BlocBuilder<BlogsViewAppBarCubit, BlogsViewAppBarState>(
            builder: (context, state) {
              if (state.isInfo) {
                return _InfoAppBar();
              } else {
                return SearchAppBar(
                  onSubmitted: (value) {},
                );
              }
            },
          );
        },
      ),
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);
}

class _InfoAppBar extends StatelessWidget {
  const _InfoAppBar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<BlogsViewSelectorCubit, BlogsViewSelectorState>(
      builder: (context, state) {
        return AppBar(
          title: const Text('Blogs'),
          actions: [
            if (state.isAll || state.isSaved) ...{
              IconButton(
                icon: const Icon(Icons.search),
                onPressed: () {
                  BlocProvider.of<BlogsViewAppBarCubit>(context).searchIconButtonPressed();
                },
              ),
            },
            if (state.isUsers) ...{
              IconButton(
                icon: Icon(Icons.add),
                onPressed: () {
                  Navigator.of(context).push(AddBlogPostFormView.route(context));
                },
              ),
            }
          ],
        );
      },
    );
  }
}
