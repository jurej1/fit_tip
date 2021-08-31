import 'package:formz/formz.dart';

enum BlogContentValidationError { invalid }

class BlogContent extends FormzInput<String, BlogContentValidationError> {
  const BlogContent.dirty([String value = '']) : super.dirty(value);
  const BlogContent.pure([String value = '']) : super.pure(value);

  @override
  BlogContentValidationError? validator(String? value) {
    if (value == null) return BlogContentValidationError.invalid;
    if (value.isEmpty) return BlogContentValidationError.invalid;

    return null;
  }
}
