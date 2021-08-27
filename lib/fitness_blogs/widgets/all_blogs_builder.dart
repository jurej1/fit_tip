import 'package:fit_tip/authentication/authentication.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../fitness_blogs.dart';

class AllBlogsBuilder extends StatelessWidget {
  const AllBlogsBuilder({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;

    return BlocBuilder<BlogPostsListBloc, BlogPostsListState>(
      builder: (context, state) {
        if (state is BlogPostsListLoading) {
          return Center(
            child: const CircularProgressIndicator(),
          );
        } else if (state is BlogPostsListLoadSuccess) {
          return SizedBox(
            height: size.height,
            width: size.width,
            child: BlogPostsListBuilder(
              blogs: state.blogs,
              hasReachedMax: state.hasReachedMax,
              onIsBottom: () {
                BlocProvider.of<BlogPostsListBloc>(context).add(
                  BlogPostsListLoadMore(
                    likedBlogs: BlocProvider.of<LikedBlogPostsBloc>(context).state,
                    savedBlogs: BlocProvider.of<SavedBlogPostsBloc>(context).state,
                    userId: BlocProvider.of<AuthenticationBloc>(context).state.user?.uid,
                  ),
                );
              },
            ),
          );
        } else if (state is BlogPostsListFail) {
          return Center(
            child: const Text('Sorry. There was an error.'),
          );
        }
        return Container();
      },
    );
  }
}
