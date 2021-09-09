import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../fitness_blogs.dart';

class AllBlogsBuilder extends StatelessWidget {
  const AllBlogsBuilder({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;

    return BlocBuilder<BlogPostsListBloc, BlogPostsBaseState>(
      builder: (context, state) {
        if (state is BlogPostsLoading) {
          return Center(
            child: const CircularProgressIndicator(),
          );
        } else if (state is BlogPostsLoadSuccess) {
          return SizedBox(
            height: size.height,
            width: size.width,
            child: BlogPostsListBuilder(
              blogs: state.blogPosts,
              hasReachedMax: state.hasReachedMax,
              onBottom: () {
                BlocProvider.of<BlogPostsListBloc>(context).add(BlogPostsLoadMoreRequested());
              },
            ),
          );
        } else if (state is BlogPostsFail) {
          return Center(
            child: const Text('Sorry. There was an error.'),
          );
        }
        return Container();
      },
    );
  }
}
