import 'package:food_repository/food_repository.dart';
import 'package:formz/formz.dart';

enum VitaminsListModelValidationError { invalid }

class VitaminsListModel extends FormzInput<List<FoodDataVitamin>, VitaminsListModelValidationError> {
  const VitaminsListModel.pure([List<FoodDataVitamin> value = const []]) : super.pure(value);
  const VitaminsListModel.dirty([List<FoodDataVitamin> value = const []]) : super.dirty(value);

  @override
  VitaminsListModelValidationError? validator(List? value) {
    if (value == null) {
      return VitaminsListModelValidationError.invalid;
    }

    return null;
  }
}
