import 'package:formz/formz.dart';
import 'package:image_picker/image_picker.dart';

enum BlogBannerValidationError { invalid }

class BlogBanner extends FormzInput<XFile?, BlogBannerValidationError> {
  const BlogBanner.dirty([XFile? value]) : super.dirty(value);
  const BlogBanner.pure([XFile? value]) : super.pure(value);

  @override
  BlogBannerValidationError? validator(XFile? value) {
    return null;
  }
}
