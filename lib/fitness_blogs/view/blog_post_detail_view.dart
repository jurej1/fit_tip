import 'package:blog_repository/blog_repository.dart';
import 'package:fit_tip/fitness_blogs/blocs/blocs.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class BlogPostDetailView extends StatelessWidget {
  const BlogPostDetailView({Key? key}) : super(key: key);

  static MaterialPageRoute route(
    BuildContext context,
    BlogPost blogPost,
  ) {
    return MaterialPageRoute(
      builder: (_) {
        return BlocProvider(
          create: (context) => BlogPostDetailBloc(
            blogPost: blogPost,
            blogRepository: RepositoryProvider.of<BlogRepository>(context),
          ),
          child: const BlogPostDetailView(),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _AppBar(),
    );
  }
}

class _AppBar extends StatelessWidget with PreferredSizeWidget {
  const _AppBar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<BlogPostDetailBloc, BlogPostDetailState>(
      builder: (context, state) {
        return AppBar(
          title: Text(state.blogPost.title),
          actions: [
            Row(
              children: [
                IconButton(
                  icon: Icon(state.blogPost.isSaved ? Icons.bookmark : Icons.bookmark_outline),
                  onPressed: () {
                    //TODO
                  },
                ),
                IconButton(
                  onPressed: () {},
                  icon: Icon(state.blogPost.isUpliked ? Icons.favorite : Icons.favorite_outline),
                ),
                Text(
                  state.blogPost.likes.toString(),
                  style: TextStyle(fontSize: 22),
                ),
                SizedBox(
                  width: 15,
                ),
              ],
            ),
          ],
        );
      },
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);
}
