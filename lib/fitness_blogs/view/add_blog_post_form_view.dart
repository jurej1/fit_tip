import 'package:blog_repository/blog_repository.dart';
import 'package:fit_tip/authentication/blocs/authentication_bloc/authentication_bloc.dart';
import 'package:fit_tip/fitness_blogs/blocs/blocs.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

class AddBlogPostFormView extends StatelessWidget {
  const AddBlogPostFormView({Key? key}) : super(key: key);

  static MaterialPageRoute route(BuildContext context) {
    return MaterialPageRoute(
      builder: (_) {
        return MultiBlocProvider(
          providers: [
            BlocProvider(
              create: (context) => AddBlogPostBloc(
                authenticationBloc: BlocProvider.of<AuthenticationBloc>(context),
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
      appBar: AppBar(),
      body: ListView(
        padding: const EdgeInsets.all(10),
        children: [
          _BlogTitleInput(),
          _BlogPostContentInput(),
          _IsPublicTile(),
          _TagsInputField(),
          _TagsDisplayer(),
        ],
      ),
    );
  }
}

class _BlogTitleInput extends StatelessWidget {
  const _BlogTitleInput({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AddBlogPostBloc, AddBlogPostState>(
      builder: (context, state) {
        return TextFormField(
          initialValue: state.title.value,
          decoration: InputDecoration(
            labelText: 'Title',
            errorText: state.title.invalid ? 'Invalid' : null,
          ),
          onChanged: (value) {
            BlocProvider.of<AddBlogPostBloc>(context).add(AddBlogPostTitleUpdated(value));
          },
        );
      },
    );
  }
}

class _BlogPostContentInput extends StatelessWidget {
  const _BlogPostContentInput({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AddBlogPostBloc, AddBlogPostState>(
      builder: (context, state) {
        return TextFormField(
          initialValue: state.content.value,
          decoration: InputDecoration(
            labelText: 'Content',
            errorText: state.content.invalid ? 'Invalid' : null,
          ),
          onChanged: (value) {
            BlocProvider.of<AddBlogPostBloc>(context).add(AddBlogPostContentUpdated(value));
          },
        );
      },
    );
  }
}

class _IsPublicTile extends StatelessWidget {
  const _IsPublicTile({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AddBlogPostBloc, AddBlogPostState>(
      builder: (context, state) {
        return ListTile(
          contentPadding: EdgeInsets.zero,
          title: Text('Public'),
          trailing: Switch(
            value: state.isPublic,
            onChanged: (value) {
              BlocProvider.of<AddBlogPostBloc>(context).add(AddBlogPostPublicPressed());
            },
          ),
        );
      },
    );
  }
}

class _TagsInputField extends HookWidget {
  const _TagsInputField({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final _textController = useTextEditingController();
    return BlocBuilder<AddBlogPostBloc, AddBlogPostState>(
      builder: (context, state) {
        return TextFormField(
          controller: _textController,
          decoration: InputDecoration(
            isDense: true,
            labelText: 'Tag',
            suffixIcon: IconButton(
              icon: const Icon(Icons.add),
              color: Colors.blue,
              splashRadius: 20,
              onPressed: () {
                BlocProvider.of<AddBlogPostBloc>(context).add(AddBlogPostTagAdded());
                _textController.clear();
              },
            ),
          ),
          onChanged: (value) {
            BlocProvider.of<AddBlogPostBloc>(context).add(AddBlogPostTagFieldUpdated(value));
          },
        );
      },
    );
  }
}

class _TagsDisplayer extends StatelessWidget {
  const _TagsDisplayer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AddBlogPostBloc, AddBlogPostState>(
      builder: (context, state) {
        return Wrap(
          spacing: 10,
          children: state.tags.value
              .map(
                (e) => Chip(
                  label: Text(e),
                  onDeleted: () {
                    BlocProvider.of<AddBlogPostBloc>(context).add(AddBlogPostTagRemoved(e));
                  },
                ),
              )
              .toList(),
        );
      },
    );
  }
}
