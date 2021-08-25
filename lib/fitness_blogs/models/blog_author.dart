import 'package:formz/formz.dart';

enum BlogAuthorValidationError { invalid }

class BlogAuthor extends FormzInput<String?, BlogAuthorValidationError> {
  const BlogAuthor.dirty([String? value]) : super.dirty(value);
  const BlogAuthor.pure([String? value]) : super.pure(value);

  @override
  BlogAuthorValidationError? validator(String? value) {
    if (value == null) return BlogAuthorValidationError.invalid;
    if (value.isEmpty) return BlogAuthorValidationError.invalid;

    return null;
  }
}
