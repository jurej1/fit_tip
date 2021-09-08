import 'package:fit_tip/authentication/authentication.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../fitness_blogs.dart';

class SavedBlogsBuilder extends StatelessWidget {
  const SavedBlogsBuilder({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;

    return BlocBuilder<BlogPostsSavedListBloc, BlogPostsSavedListState>(
      builder: (context, state) {
        if (state is BlogPostsSavedListLoading) {
          return const Center(
            child: const CircularProgressIndicator(),
          );
        } else if (state is BlogPostsSavedListLoadSuccess) {
          return SizedBox(
            height: size.height,
            width: size.width,
            child: BlogPostsListBuilder(
              blogs: state.blogs,
              hasReachedMax: state.hasReachedMax,
              onBottom: () {
                BlocProvider.of<BlogPostsSavedListBloc>(context).add(
                  BlogPostsSavedListLoadMoreRequested(),
                );
              },
            ),
          );
        } else if (state is BlogPostsSavedListFailure) {
          return Center(
            child: const Text('Sorry. There was an error.'),
          );
        }
        return Container();
      },
    );
  }
}
