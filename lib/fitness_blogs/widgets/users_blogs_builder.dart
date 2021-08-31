import 'package:fit_tip/authentication/authentication.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../fitness_blogs.dart';

class UserBlogsBuilder extends StatelessWidget {
  const UserBlogsBuilder({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;

    return BlocBuilder<UserBlogPostsListBloc, UserBlogPostsListState>(
      builder: (context, state) {
        if (state is UserBlogPostsListLoading) {
          return const Center(
            child: const CircularProgressIndicator(),
          );
        } else if (state is UserBlogPostsListLoadSuccess) {
          return SizedBox(
            height: size.height,
            width: size.width,
            child: BlogPostsListBuilder(
              blogs: state.blogs,
              hasReachedMax: state.hasReachedMax,
              onIsBottom: () {
                BlocProvider.of<UserBlogPostsListBloc>(context).add(UserBlogPostsListLoadMoreRequested());
              },
            ),
          );
        } else if (state is UserBlogPostsListFail) {
          return Center(
            child: const Text('Sorry. There was an error.'),
          );
        }
        return Container();
      },
    );
  }
}
