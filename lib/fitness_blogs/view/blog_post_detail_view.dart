import 'dart:developer';

import 'package:blog_repository/blog_repository.dart';
import 'package:fit_tip/fitness_blogs/blocs/blocs.dart';
import 'package:fit_tip/fitness_blogs/fitness_blogs.dart';
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
          listenWhen: (p, c) => p.blogPost.like != c.blogPost.like,
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
          listenWhen: (p, c) => p.blogPost.isSaved == c.blogPost.isSaved,
          listener: (context, state) {
            BlocProvider.of<BlogPostsSavedListBloc>(context).add(BlogPostsSavedListItemUpdated(state.blogPost));
          },
        ),
        BlocListener<BlogPostDetailBloc, BlogPostDetailState>(
          listener: (context, state) {
            BlocProvider.of<BlogPostsListBloc>(context).add(BlogPostsListItemUpdated(state.blogPost));
          },
        ),
      ],
      child: Scaffold(
        appBar: DetailBlogPostAppBar(),
        body: BlocBuilder<BlogPostDetailBloc, BlogPostDetailState>(
          builder: (context, state) {
            return ListView(
              children: [
                if (state.blogPost.bannerUrl != null)
                  Container(
                    height: size.width,
                    width: size.width,
                    child: Image.network(
                      state.blogPost.bannerUrl!,
                      fit: BoxFit.cover,
                      loadingBuilder: (context, child, loadingProgress) {
                        if (loadingProgress == null) return child;
                        return Center(
                          child: CircularProgressIndicator(
                            value: loadingProgress.expectedTotalBytes != null
                                ? (loadingProgress.cumulativeBytesLoaded / loadingProgress.expectedTotalBytes!)
                                : null,
                          ),
                        );
                      },
                    ),
                  ),
                Text(state.blogPost.title),
              ],
            );
          },
        ),
      ),
    );
  }
}
