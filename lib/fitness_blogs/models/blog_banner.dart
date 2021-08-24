import 'dart:io';

import 'package:formz/formz.dart';

enum BlogBannerValidationError { invalid }

class BlogBanner extends FormzInput<File?, BlogBannerValidationError> {
  const BlogBanner.dirty([File? value]) : super.dirty(value);
  const BlogBanner.pure([File? value]) : super.pure(value);

  @override
  BlogBannerValidationError? validator(File? value) {
    return null;
  }
}
