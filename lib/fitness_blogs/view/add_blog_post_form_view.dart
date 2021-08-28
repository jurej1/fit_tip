import 'package:fit_tip/authentication/authentication.dart';
import 'package:blog_repository/blog_repository.dart';
import 'package:fit_tip/fitness_blogs/blocs/blocs.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formz/formz.dart';

import '../fitness_blogs.dart';

class AddBlogPostFormView extends StatelessWidget {
  const AddBlogPostFormView({Key? key}) : super(key: key);

  static MaterialPageRoute route(BuildContext context) {
    final userBlogPostsBloc = BlocProvider.of<UserBlogPostsListBloc>(context);

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
          child: AddBlogPostFormView(),
        );
      },
    );
  }

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
      body: BlocConsumer<AddBlogPostBloc, AddBlogPostState>(
        listener: (context, state) {
          if (state.status.isSubmissionSuccess) {
            BlocProvider.of<UserBlogPostsListBloc>(context).add(
              UserBlogPostsListItemAdded(
                state.blogPost!,
                BlocProvider.of<AuthenticationBloc>(context).state.user?.uid,
              ),
            );
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Blog added successfully')));
            Navigator.of(context).pop();
          } else if (state.status.isSubmissionFailure) {
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Failure')));
          }
        },
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
              TagsDisplayer(),
              BannerPicker(),
              BannerDisplayer(),
            ],
          );
        },
      ),
    );
  }
}
