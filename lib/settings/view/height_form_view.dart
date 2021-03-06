import 'dart:developer';

import 'package:fit_tip/fitness_tracking/widgets/widgets.dart';
import 'package:fit_tip/settings/blocs/blocs.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HeightFormView extends StatelessWidget {
  const HeightFormView({Key? key, required this.onSubmit}) : super(key: key);

  final void Function(int value) onSubmit;

  static MaterialPageRoute<int?> route(BuildContext context, void Function(int value) onSubmit, {int? initialValue}) {
    return MaterialPageRoute<int?>(
      builder: (_) {
        return MultiBlocProvider(
          providers: [
            BlocProvider(
              create: (context) => HeightFormBloc(initialValue: initialValue ?? 160),
            ),
          ],
          child: HeightFormView(
            onSubmit: onSubmit,
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Height'),
        actions: [
          BlocBuilder<HeightFormBloc, int>(
            builder: (context, value) {
              return IconButton(
                icon: const Icon(Icons.check),
                onPressed: () {
                  onSubmit(value);
                },
              );
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(10),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Height (cm)'),
                BlocBuilder<HeightFormBloc, int>(
                  builder: (context, val) {
                    return DraggableValueSelector.route(
                      itemHeight: 20,
                      onValueUpdated: (val) {
                        log('updating');
                        BlocProvider.of<HeightFormBloc>(context).add(HeightFormHeightUpdated(val));
                      },
                      focusedValue: val,
                      itemCount: 250,
                      height: 100,
                      width: 40,
                    );
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
