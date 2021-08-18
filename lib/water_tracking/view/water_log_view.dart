import 'package:fit_tip/authentication/authentication.dart';
import 'package:fit_tip/shared/blocs/blocs.dart';
import 'package:fit_tip/water_tracking/water_tracking.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:water_repository/water_repository.dart';

class WaterLogView extends StatelessWidget {
  static List<BlocProvider> _providers() => [
        BlocProvider<DaySelectorBloc>(
          create: (context) => DaySelectorBloc(),
        ),
        BlocProvider<WaterLogDayBloc>(
          create: (context) => WaterLogDayBloc(
            waterRepository: RepositoryProvider.of<WaterRepository>(context),
            authenticationBloc: BlocProvider.of<AuthenticationBloc>(context),
          )..add(WaterLogFocusedDayUpdated(BlocProvider.of<DaySelectorBloc>(context).state.selectedDate)),
        ),
        BlocProvider<WaterDailyGoalBloc>(create: (context) {
          return WaterDailyGoalBloc(
            authenticationBloc: BlocProvider.of<AuthenticationBloc>(context),
            waterRepository: RepositoryProvider.of<WaterRepository>(context),
          )..add(WaterDailyGoalDateUpdated(BlocProvider.of<DaySelectorBloc>(context).state.selectedDate));
        }),
        BlocProvider<WaterLogConsumptionBloc>(
          create: (context) => WaterLogConsumptionBloc(
            waterDailyGoalBloc: BlocProvider.of<WaterDailyGoalBloc>(context),
            waterLogDayBloc: BlocProvider.of<WaterLogDayBloc>(context),
          ),
        ),
      ];

  static MaterialPageRoute route(BuildContext context) {
    return MaterialPageRoute(
      builder: (_) {
        return WaterLogView.provider(context);
      },
    );
  }

  static Widget provider(BuildContext context) {
    return MultiBlocProvider(
      providers: _providers(),
      child: WaterLogView(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Water tracking'),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () {
              Navigator.of(context).push(AddWaterDailyGoalView.route(context));
            },
          ),
        ],
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
                    value: BlocProvider.of<DaySelectorBloc>(context),
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
