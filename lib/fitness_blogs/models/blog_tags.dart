import 'package:formz/formz.dart';

enum BlogTagsValidationError { invalid }

class BlogTags extends FormzInput<List<String>, BlogTagsValidationError> {
  const BlogTags.dirty([List<String> value = const []]) : super.dirty(value);
  const BlogTags.pure([List<String> value = const []]) : super.pure(value);

  @override
  BlogTagsValidationError? validator(List<String>? value) {
    return null;
  }
}
