import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../fitness_blogs.dart';

class InfoAppBar extends StatelessWidget with PreferredSizeWidget {
  const InfoAppBar({Key? key}) : super(key: key);

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
                onPressed: () async {
                  BlogSearchResult? value = await Navigator.of(context).push<BlogSearchResult?>(BlogSearchView.route(context));

                  if (state.isAll) {}
                  if (state.isSaved) {}
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
  Size get preferredSize {
    return Size.fromHeight(kToolbarHeight);
  }
}
