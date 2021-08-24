import 'package:fit_tip/authentication/authentication.dart';
import 'package:image_picker/image_picker.dart';
import 'package:blog_repository/blog_repository.dart';
import 'package:fit_tip/fitness_blogs/blocs/blocs.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:formz/formz.dart';

class AddBlogPostFormView extends StatelessWidget {
  const AddBlogPostFormView({Key? key}) : super(key: key);

  static MaterialPageRoute route(BuildContext context) {
    return MaterialPageRoute(
      builder: (_) {
        return MultiBlocProvider(
          providers: [
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
              _BlogTitleInput(),
              const SizedBox(height: 10),
              _BlogPostContentInput(),
              _IsPublicTile(),
              _TagsInputField(),
              _TagsDisplayer(),
              _BannerPicker(),
              _BannerDisplayer(),
            ],
          );
        },
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
          textAlignVertical: TextAlignVertical.top,
          minLines: 5,
          maxLines: 10,
          decoration: InputDecoration(
            alignLabelWithHint: true,
            labelText: 'Content',
            errorText: state.content.invalid ? 'Invalid' : null,
            border: OutlineInputBorder(),
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
          readOnly: state.tags.hasReachedMaxAmount(),
          controller: _textController,
          decoration: InputDecoration(
            isDense: true,
            labelText: 'Tag',
            errorText: state.tags.hasReachedMaxAmount() ? 'You have reached the max amount' : null,
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

class _BannerPicker extends StatelessWidget {
  _BannerPicker({Key? key}) : super(key: key);

  final ImagePicker _imagePicker = ImagePicker();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AddBlogPostBloc, AddBlogPostState>(
      builder: (context, state) {
        return ListTile(
          contentPadding: EdgeInsets.zero,
          title: Text('Pick banner'),
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              IconButton(
                icon: const Icon(Icons.camera),
                onPressed: () {
                  _pickImage(context, ImageSource.camera);
                },
              ),
              IconButton(
                icon: const Icon(Icons.photo),
                onPressed: () {
                  _pickImage(context, ImageSource.gallery);
                },
              )
            ],
          ),
        );
      },
    );
  }

  Future<void> _pickImage(BuildContext context, ImageSource source) async {
    XFile? file = await _imagePicker.pickImage(
      source: source,
      imageQuality: 70,
    );
    BlocProvider.of<AddBlogPostBloc>(context).add(AddBlogPostBannerUpdated(file));
  }
}

class _BannerDisplayer extends StatelessWidget {
  const _BannerDisplayer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    return BlocBuilder<AddBlogPostBloc, AddBlogPostState>(
      builder: (context, state) {
        return Container(
          width: size.width,
          height: 200,
          child: state.banner.value != null ? Image.file(state.banner.value!) : null,
        );
      },
    );
  }
}
