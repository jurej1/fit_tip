import 'package:fit_tip/food_tracking/blocs/blocs.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:food_repository/food_repository.dart';
import 'package:formz/formz.dart';

class VitaminInputForm extends StatelessWidget {
  const VitaminInputForm({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;

    return BlocListener<AddVitaminFormBloc, AddVitaminFormState>(
      listener: (context, state) {
        if (state.status.isSubmissionSuccess) {
          BlocProvider.of<AddFoodItemBloc>(context).add(AddFooditemVitaminAdded(vitamin: state.vitaminModel));
          Navigator.of(context).pop();
        }
      },
      child: Container(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 10),
          child: Column(
            children: [
              const SizedBox(height: 10),
              Container(
                decoration: BoxDecoration(
                  color: Colors.grey,
                  borderRadius: BorderRadius.circular(10),
                ),
                height: 10,
                width: size.width * 0.4,
              ),
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Vitamin: '),
                  BlocBuilder<AddVitaminFormBloc, AddVitaminFormState>(
                    builder: (context, state) {
                      return DropdownButton<Vitamin>(
                        value: state.vitamin.value,
                        onChanged: (value) {
                          BlocProvider.of<AddVitaminFormBloc>(context).add(AddVitaminFormVitaminChanged(vitamin: value));
                        },
                        items: Vitamin.values
                            .map(
                              (e) => DropdownMenuItem(
                                child: Text(
                                  describeEnum(e),
                                ),
                                value: e,
                              ),
                            )
                            .toList(),
                      );
                    },
                  ),
                ],
              ),
              BlocBuilder<AddVitaminFormBloc, AddVitaminFormState>(
                builder: (context, state) {
                  return TextFormField(
                    initialValue: '0',
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      prefixIcon: Text('Amount: '),
                      suffixIcon: Text(' g'),
                    ),
                    textAlign: TextAlign.right,
                    onChanged: (val) => BlocProvider.of<AddVitaminFormBloc>(context).add(AddVitaminFormAmountChanged(amount: val)),
                  );
                },
              ),
              ElevatedButton(
                child: Text('Add'),
                onPressed: () {
                  BlocProvider.of<AddVitaminFormBloc>(context).add(AddVitaminFormAmountFormSubmit());
                },
              ),
              const SizedBox(height: 50),
            ],
          ),
        ),
      ),
    );
  }
}
