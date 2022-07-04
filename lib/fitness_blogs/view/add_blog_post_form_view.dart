import 'package:fit_tip/authentication/authentication.dart';
import 'package:blog_repository/blog_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formz/formz.dart';

import '../fitness_blogs.dart';

class AddBlogPostFormView extends StatelessWidget {
  const AddBlogPostFormView({Key? key}) : super(key: key);

  static MaterialPageRoute route(BuildContext context, {BlogPost? blog}) {
    final userBlogPostsBloc = BlocProvider.of<UserBlogPostsBloc>(context);

    return MaterialPageRoute(
      builder: (_) {
        return MultiBlocProvider(
          providers: [
            BlocProvider.value(value: userBlogPostsBloc),
            BlocProvider(
              create: (context) => AddBlogPostBloc(
                userDataBloc: BlocProvider.of<UserDataBloc>(context),
                blogRepository: RepositoryProvider.of<BlogRepository>(context),
              ),
            ),
          ],
          child: const AddBlogPostFormView(),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AddBlogPostBloc, AddBlogPostState>(
      listener: (context, state) {
        if (state.status.isSubmissionSuccess) {
          BlocProvider.of<UserBlogPostsBloc>(context).add(BlogPostsItemAdded(state.blogPost!));
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Blog added successfully')));
          Navigator.of(context).pop();
        } else if (state.status.isSubmissionFailure) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Failure')));
        }
      },
      child: const _ViewBuilder(),
    );
  }
}

class _ViewBuilder extends StatelessWidget {
  const _ViewBuilder({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add blog post'),
        actions: [
          IconButton(
            icon: const Icon(Icons.check),
            onPressed: () {
              BlocProvider.of<AddBlogPostBloc>(context).add(AddBlogPostSubmit());
            },
          ),
        ],
      ),
      body: BlocBuilder<AddBlogPostBloc, AddBlogPostState>(
        builder: (context, state) {
          if (state.status.isSubmissionInProgress) {
            return const Center(
              child: const CircularProgressIndicator(),
            );
          }

          return ListView(
            padding: const EdgeInsets.all(10),
            children: [
              BlogTitleInput(),
              const SizedBox(height: 10),
              BlogPostContentInput(),
              IsPublicTile(),
              TagsInputField(),
              TagsInputDisplayer(),
              BannerPicker(),
              BannerDisplayer(),
            ],
          );
        },
      ),
    );
  }
}
