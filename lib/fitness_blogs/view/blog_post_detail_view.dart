import 'dart:math';

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
    final savedBlogPostsBloc = BlocProvider.of<SavedBlogPostsBloc>(context);
    final likedBlogPostsBloc = BlocProvider.of<LikedBlogPostsBloc>(context);
    final blogPostsSavedListBloc = BlocProvider.of<BlogPostsSavedListBloc>(context);
    final blogPostsListBloc = BlocProvider.of<BlogPostsListBloc>(context);
    return MaterialPageRoute(
      builder: (_) {
        return MultiBlocProvider(
          providers: [
            //Hydrated blocs
            BlocProvider.value(value: savedBlogPostsBloc),
            BlocProvider.value(value: likedBlogPostsBloc),
            //Blogs with blogPosts
            BlocProvider.value(value: blogPostsSavedListBloc),
            BlocProvider.value(value: blogPostsListBloc),
            //Save and like feature blocs
            BlocProvider(
              create: (context) => BlogPostSaveCubit(
                initialValue: blogPost.isSaved,
              ),
            ),
            BlocProvider(
              create: (context) => BlogPostLikeCubit(
                blogId: blogPost.id,
                blogRepository: RepositoryProvider.of<BlogRepository>(context),
                initialValue: blogPost.like,
                likesAmount: blogPost.likes,
              ),
            ),
            //Detail blog view bloc
            BlocProvider(
              create: (context) => BlogPostDetailBloc(
                blogPost: blogPost,
                blogRepository: RepositoryProvider.of<BlogRepository>(context),
              ),
            ),
          ],
          child: const BlogPostDetailView(),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;

    return MultiBlocListener(
      listeners: [
        BlocListener<BlogPostDetailBloc, BlogPostDetailState>(
          listenWhen: (p, c) => p.blogPost.isSaved != c.blogPost.isSaved,
          listener: (context, state) {
            if (state.blogPost.isSaved) {
              BlocProvider.of<SavedBlogPostsBloc>(context).add(SavedBlogPostsItemAdded(state.blogPost.id));
              BlocProvider.of<BlogPostsSavedListBloc>(context).add(BlogPostsSavedListItemAdded(state.blogPost));
            }

            if (!state.blogPost.isSaved) {
              BlocProvider.of<SavedBlogPostsBloc>(context).add(SavedBlogPostsItemRemoved(state.blogPost.id));
              BlocProvider.of<BlogPostsSavedListBloc>(context).add(BlogPostsSavedListItemRemoved(state.blogPost));
            }
          },
        ),
        BlocListener<BlogPostDetailBloc, BlogPostDetailState>(
          listenWhen: (p, c) => p.blogPost.like == c.blogPost.like,
          listener: (context, state) {
            if (state.blogPost.like.isYes) {
              BlocProvider.of<LikedBlogPostsBloc>(context).add(LikedBlogPostsItemAdded(state.blogPost.id));
            }
            if (state.blogPost.like.isNo) {
              BlocProvider.of<LikedBlogPostsBloc>(context).add(LikedBlogPostsItemRemoved(state.blogPost.id));
            }
          },
        ),
        BlocListener<BlogPostDetailBloc, BlogPostDetailState>(
          listener: (context, state) {
            BlocProvider.of<BlogPostsSavedListBloc>(context).add(BlogPostsSavedListItemUpdated(state.blogPost));
            BlocProvider.of<BlogPostsListBloc>(context).add(BlogPostsListItemUpdated(state.blogPost));
          },
        ),
      ],
      child: Scaffold(
        appBar: _AppBar(),
        body: BlocBuilder<BlogPostDetailBloc, BlogPostDetailState>(
          builder: (context, state) {
            return ListView(
              children: [
                if (state.blogPost.bannerUrl != null)
                  Container(
                    height: min(size.height, size.width),
                    width: min(size.height, size.width),
                    child: Image.network(
                      state.blogPost.bannerUrl!,
                      fit: BoxFit.cover,
                      loadingBuilder: (context, child, loadingProgress) {
                        if (loadingProgress == null) return child;
                        return Center(
                          child: CircularProgressIndicator(),
                        );
                      },
                    ),
                  ),
                Text('\b\b Hello\b'),
              ],
            );
          },
        ),
      ),
    );
  }
}

class _AppBar extends StatelessWidget with PreferredSizeWidget {
  const _AppBar({Key? key}) : super(key: key);

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
