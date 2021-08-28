import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:blog_repository/blog_repository.dart';
import '../fitness_blogs.dart';

class DetailBlogPostAppBar extends StatelessWidget with PreferredSizeWidget {
  const DetailBlogPostAppBar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
      listeners: [
        BlocListener<BlogPostLikeCubit, BlogPostLikeState>(
          listener: (context, state) {
            if (state is BlogPostLikeSuccess) {
              BlocProvider.of<BlogPostDetailBloc>(context).add(BlogPostDetailLikeUpdated(state.like, state.likesAmount));
            }
          },
        ),
        BlocListener<BlogPostSaveCubit, BlogPostSaveState>(
          listener: (context, state) {
            BlocProvider.of<BlogPostDetailBloc>(context).add(BlogPostDetailSaveUpdated(state.isSaved));
          },
        ),
      ],
      child: BlocBuilder<BlogPostDetailBloc, BlogPostDetailState>(
        builder: (context, state) {
          return AppBar(
            title: Text(state.blogPost.title),
            actions: [
              Row(
                children: [
                  BlocBuilder<BlogPostSaveCubit, BlogPostSaveState>(
                    builder: (context, state) {
                      return IconButton(
                        icon: Icon(state.isSaved ? Icons.bookmark : Icons.bookmark_outline),
                        onPressed: () {
                          BlocProvider.of<BlogPostSaveCubit>(context).buttonPressed();
                        },
                      );
                    },
                  ),
                  BlocBuilder<BlogPostLikeCubit, BlogPostLikeState>(
                    builder: (context, state) {
                      return IconButton(
                        icon: Icon(state.like.isYes ? Icons.favorite : Icons.favorite_outline),
                        onPressed: () {
                          BlocProvider.of<BlogPostLikeCubit>(context).buttonPressed();
                        },
                      );
                    },
                  ),
                  BlocBuilder<BlogPostLikeCubit, BlogPostLikeState>(
                    builder: (context, state) {
                      return Text(
                        state.likesAmount.toString(),
                        style: TextStyle(fontSize: 22),
                      );
                    },
                  ),
                  SizedBox(
                    width: 15,
                  ),
                ],
              ),
            ],
          );
        },
      ),
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);
}