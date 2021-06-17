import 'package:fit_tip/food_tracking/blocs/blocs.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:food_repository/food_repository.dart';

class VitaminInputForm extends StatelessWidget {
  const VitaminInputForm({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;

    return Container(
      child: Column(
        children: [
          const SizedBox(height: 10),
          Container(
            decoration: BoxDecoration(
              color: Colors.grey,
              borderRadius: BorderRadius.circular(10),
            ),
            height: 5,
            width: size.width * 0.4,
          ),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Vitamin: '),
              DropdownButton<Vitamin>(
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
              ),
            ],
          ),
        ],
      ),
    );
  }
}
