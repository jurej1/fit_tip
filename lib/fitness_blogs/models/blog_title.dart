import 'package:formz/formz.dart';

enum BlogTitleValidationError { invalid }

class BlogTitle extends FormzInput<String, BlogTitleValidationError> {
  const BlogTitle.dirty([String value = '']) : super.dirty(value);
  const BlogTitle.pure([String value = '']) : super.pure(value);

  @override
  BlogTitleValidationError? validator(String? value) {
    if (value == null) return BlogTitleValidationError.invalid;
    if (value.length > 100) return BlogTitleValidationError.invalid;

    return null;
  }
}
