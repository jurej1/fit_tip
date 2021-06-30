import 'package:fit_tip/authentication/blocs/blocs.dart';
import 'package:fit_tip/shared/blocs/blocs.dart';
import 'package:fit_tip/water_tracking/blocs/add_water_daily_goal/add_water_daily_goal_bloc.dart';
import 'package:fit_tip/water_tracking/blocs/blocs.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formz/formz.dart';
import 'package:water_repository/water_repository.dart';

class AddWaterDailyGoalView extends StatelessWidget {
  static MaterialPageRoute route(BuildContext context) {
    final waterDailyGoalBloc = BlocProvider.of<WaterDailyGoalBloc>(context);
    final daySelectorBloc = BlocProvider.of<DaySelectorBloc>(context);

    return MaterialPageRoute(builder: (_) {
      return MultiBlocProvider(
        providers: [
          BlocProvider<AddWaterDailyGoalBloc>(
            create: (context) => AddWaterDailyGoalBloc(
              waterDailyGoalBloc: waterDailyGoalBloc,
              waterLogFocusedDayBloc: daySelectorBloc,
              waterRepository: RepositoryProvider.of<WaterRepository>(context),
              authenticationBloc: BlocProvider.of<AuthenticationBloc>(context),
            ),
          ),
          BlocProvider.value(
            value: waterDailyGoalBloc,
          ),
        ],
        child: AddWaterDailyGoalView(),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AddWaterDailyGoalBloc, AddWaterDailyGoalState>(
      listener: (context, state) {
        if (state.status.isSubmissionSuccess) {
          BlocProvider.of<WaterDailyGoalBloc>(context).add(WaterDailyGoalAmountUpdated(double.tryParse(state.amount.value)!));
          Navigator.of(context).pop();
        }
      },
      child: Scaffold(
        appBar: AppBar(
          actions: [
            BlocBuilder<AddWaterDailyGoalBloc, AddWaterDailyGoalState>(
              builder: (context, state) {
                return IconButton(
                  icon: state.status.isSubmissionInProgress
                      ? const SizedBox(height: 30, width: 30, child: const CircularProgressIndicator())
                      : const Icon(Icons.check),
                  onPressed: () => BlocProvider.of<AddWaterDailyGoalBloc>(context).add(AddWaterDailyGoalFormSubmit()),
                );
              },
            )
          ],
        ),
        body: ListView(
          padding: const EdgeInsets.symmetric(horizontal: 15),
          physics: const ClampingScrollPhysics(),
          children: [
            _AmountInput(),
          ],
        ),
      ),
    );
  }
}

class _AmountInput extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AddWaterDailyGoalBloc, AddWaterDailyGoalState>(
      builder: (context, state) {
        return Row(
          children: [
            Text('Amount'),
            Expanded(
              child: TextFormField(
                textAlign: TextAlign.right,
                initialValue: state.amount.value,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  errorText: state.amount.invalid ? 'Invalid' : null,
                  border: InputBorder.none,
                ),
                onChanged: (val) => BlocProvider.of<AddWaterDailyGoalBloc>(context).add(AddWaterDailyGoalAmountChanged(val)),
              ),
            ),
            Text('ml'),
          ],
        );
      },
    );
  }
}
