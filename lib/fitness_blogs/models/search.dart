import 'package:formz/formz.dart';

enum SearchValidationError { invalid }

class Search extends FormzInput<String, SearchValidationError> {
  const Search.dirty([String value = '']) : super.dirty(value);
  const Search.pure([String value = '']) : super.pure(value);

  @override
  SearchValidationError? validator(String? value) {
    return null;
  }
}
