import 'package:formz/formz.dart';

enum BlogBannerValidationError { invalid }

class BlogBanner extends FormzInput<String?, BlogBannerValidationError> {
  const BlogBanner.dirty([String? value]) : super.dirty(value);
  const BlogBanner.pure([String? value]) : super.pure(value);

  @override
  BlogBannerValidationError? validator(String? value) {
    return null;
  }
}
