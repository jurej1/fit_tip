import 'package:fitness_repository/fitness_repository.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:fit_tip/excercise_tracking/excercise_tracking.dart';

class IntensityInput extends StatelessWidget {
  const IntensityInput({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AddExcerciseLogBloc, AddExcerciseLogState>(
      builder: (context, state) {
        return ListTile(
          contentPadding: EdgeInsets.zero,
          leading: Text(
            'Intensity',
          ),
          trailing: Text(describeEnum(state.intensity.value)),
          onTap: () async {
            FocusScope.of(context).unfocus();

            Intensity? intensitsy = await showModalBottomSheet<Intensity?>(
              context: context,
              isScrollControlled: true,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(10),
                  topRight: Radius.circular(10),
                ),
              ),
              builder: (_) {
                return _BottomSheet(selectedIntensity: state.intensity.value);
              },
            );

            BlocProvider.of<AddExcerciseLogBloc>(context).add(AddExcerciseLogIntensityUpdated(intensitsy));
          },
        );
      },
    );
  }
}

class _BottomSheet extends StatelessWidget {
  const _BottomSheet({
    Key? key,
    this.selectedIntensity,
  }) : super(key: key);

  final Intensity? selectedIntensity;

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;

    return Container(
      height: size.height * 0.45,
      child: ExcerciseLogBottomSheet(
        itemCount: Intensity.values.length,
        itemBuilder: (context, index) {
          final item = Intensity.values[index];
          final bool isSelected = selectedIntensity == item;

          return ListTile(
            title: Text(
              describeEnum(item),
              style: TextStyle(color: isSelected ? Colors.blue : Colors.black),
            ),
            onTap: () {
              Navigator.of(context).pop(item);
            },
          );
        },
      ),
    );
  }
}
