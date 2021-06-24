import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:fit_tip/food_tracking/food_tracking.dart';

class FoodItemDetailForm extends StatelessWidget {
  const FoodItemDetailForm({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AddFoodItemBloc, AddFoodItemState>(
      builder: (context, state) {
        if (!state.showDetail) return Container();

        return Column(
          children: [
            _FatsInputField(),
            _CarbsInputField(),
            _ProteinInputField(),
            FoodItemVitaminsInputTile(),
            _VitaminsList(),
          ],
        );
      },
    );
  }
}

class _FatsInputField extends StatelessWidget {
  const _FatsInputField({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AddFoodItemBloc, AddFoodItemState>(
      builder: (context, state) {
        return FoodItemDetailInputField(
          errorText: 'Invalid',
          initialValue: state.fats.value,
          isInvalid: state.fats.invalid,
          labelText: 'Fats',
          onChanged: (val) => BlocProvider.of<AddFoodItemBloc>(context).add(AddFoodItemFatsChanged(value: val)),
        );
      },
    );
  }
}

class _CarbsInputField extends StatelessWidget {
  const _CarbsInputField({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AddFoodItemBloc, AddFoodItemState>(
      builder: (context, state) {
        return FoodItemDetailInputField(
          errorText: 'Invalid',
          isInvalid: state.carbs.invalid,
          initialValue: state.carbs.value,
          labelText: 'Carbs',
          onChanged: (val) => BlocProvider.of<AddFoodItemBloc>(context).add(
            AddFoodItemCarbsChanged(value: val),
          ),
        );
      },
    );
  }
}

class _ProteinInputField extends StatelessWidget {
  const _ProteinInputField({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AddFoodItemBloc, AddFoodItemState>(
      builder: (context, state) {
        return FoodItemDetailInputField(
          initialValue: state.proteins.value,
          errorText: 'Invalid',
          isInvalid: state.proteins.invalid,
          labelText: 'Protein',
          onChanged: (val) => BlocProvider.of<AddFoodItemBloc>(context).add(
            AddFoodItemProteinChanged(value: val),
          ),
        );
      },
    );
  }
}

class _VitaminsList extends StatelessWidget {
  const _VitaminsList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AddFoodItemBloc, AddFoodItemState>(
      builder: (context, state) {
        if (state.vitamins.value.isEmpty) return Container();

        return ListView.builder(
          physics: const NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          itemCount: state.vitamins.value.length,
          itemBuilder: (context, index) {
            final item = state.vitamins.value[index];

            return ListTile(
              contentPadding: EdgeInsets.zero,
              title: Text(
                'Vitamin ' + describeEnum(item.vitamin),
              ),
              trailing: Text(
                item.amount.toStringAsFixed(0) + 'g',
              ),
            );
          },
        );
      },
    );
  }
}
