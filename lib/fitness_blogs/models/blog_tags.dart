import 'package:formz/formz.dart';

enum BlogTagsValidationError { invalid }

class BlogTags extends FormzInput<List<String>, BlogTagsValidationError> {
  const BlogTags.dirty([List<String> value = const []]) : super.dirty(value);
  const BlogTags.pure([List<String> value = const []]) : super.pure(value);

  final int maxAmount = 5;

  bool hasReachedMaxAmount() => this.value.length >= maxAmount;

  @override
  BlogTagsValidationError? validator(List<String>? value) {
    if (value == null) return null;

    if (value.length > maxAmount) return BlogTagsValidationError.invalid;

    return null;
  }
}
