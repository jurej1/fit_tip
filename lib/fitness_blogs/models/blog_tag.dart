import 'package:formz/formz.dart';

enum BlogTagValidationError { invalid }

class BlogTag extends FormzInput<String, BlogTagValidationError> {
  const BlogTag.dirty([String value = '']) : super.dirty(value);
  const BlogTag.pure([String value = '']) : super.pure(value);

  bool get endsEmpty => this.value.endsWith('');

  @override
  BlogTagValidationError? validator(String? value) {
    return null;
  }
}
