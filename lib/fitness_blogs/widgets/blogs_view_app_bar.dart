import 'package:fit_tip/fitness_blogs/view/blogs_search_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../fitness_blogs.dart';

class BlogsViewAppBar extends StatelessWidget with PreferredSizeWidget {
  const BlogsViewAppBar({Key? key}) : super(key: key);

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
                  Navigator.of(context).push<String?>(BlogsSearchView.route<String?>(context));
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

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);
}
