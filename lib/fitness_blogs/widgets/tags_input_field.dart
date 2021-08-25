import 'dart:developer';

import 'package:fit_tip/fitness_blogs/fitness_blogs.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

class TagsInputField extends HookWidget {
  const TagsInputField({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final _textController = useTextEditingController();
    return BlocConsumer<AddBlogPostBloc, AddBlogPostState>(
      listener: (context, state) {
        if (state.blogTag.pure) {
          _textController.clear();
        }

        if (state.blogTag.endsEmpty) {
          BlocProvider.of<AddBlogPostBloc>(context).add(AddBlogPostTagAdded());
        }
      },
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
