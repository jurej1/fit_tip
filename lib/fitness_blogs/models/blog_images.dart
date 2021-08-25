import 'dart:io';

import 'package:formz/formz.dart';

enum BlogImagesValidationError { invalid }

class BlogImages extends FormzInput<List<File>?, BlogImagesValidationError> {
  const BlogImages.dirty(List<File>? value) : super.dirty(value);
  const BlogImages.pure(List<File>? value) : super.pure(value);

  @override
  BlogImagesValidationError? validator(List? value) {
    if (value != null && value.length > 10) return BlogImagesValidationError.invalid;
    return null;
  }
}
