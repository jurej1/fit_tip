import 'package:fit_tip/fitness_blogs/fitness_blogs.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class BlogPostContentInput extends StatelessWidget {
  const BlogPostContentInput({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AddBlogPostBloc, AddBlogPostState>(
      builder: (context, state) {
        return TextFormField(
          enableInteractiveSelection: true,
          initialValue: state.content.value,
          textAlignVertical: TextAlignVertical.top,
          minLines: 5,
          maxLines: 10,
          decoration: InputDecoration(
            alignLabelWithHint: true,
            labelText: 'Content',
            errorText: state.content.invalid ? 'Invalid' : null,
            border: InputBorder.none,
          ),
          onChanged: (value) {
            BlocProvider.of<AddBlogPostBloc>(context).add(AddBlogPostContentUpdated(value));
          },
        );
      },
    );
  }
}
