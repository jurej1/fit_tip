import 'package:fit_tip/water_tracking/water_tracking.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class WaterLogView extends StatelessWidget {
  static const routeName = 'water_log_view';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Water tracking'),
      ),
      body: Column(
        children: [
          WaterLogDaySelector(),
          WaterLogBuilder(),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showModalBottomSheet(
            shape: RoundedRectangleBorder(
              borderRadius: const BorderRadius.only(
                topLeft: const Radius.circular(10),
                topRight: const Radius.circular(10),
              ),
            ),
            context: context,
            isScrollControlled: true,
            builder: (_) {
              return MultiBlocProvider(
                providers: [
                  BlocProvider.value(
                    value: BlocProvider.of<WaterLogDayBloc>(context),
                    child: AddWaterLogSheet(),
                  ),
                  BlocProvider.value(
                    value: BlocProvider.of<WaterLogFocusedDayBloc>(context),
                  ),
                ],
                child: AddWaterLogSheet(),
              );
            },
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
