import 'package:activity_repository/activity_repository.dart';
import 'package:fit_tip/authentication/authentication.dart';
import 'package:fit_tip/excercise_tracking/blocs/blocs.dart';
import 'package:fit_tip/excercise_tracking/widgets/widgets.dart';
import 'package:fit_tip/food_tracking/food_tracking.dart';
import 'package:fit_tip/shared/blocs/blocs.dart';
import 'package:fit_tip/shared/shared.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formz/formz.dart';
import 'package:intl/intl.dart';

class AddExcerciseLogView extends StatelessWidget {
  const AddExcerciseLogView({Key? key}) : super(key: key);

  static route(BuildContext context) {
    final excerciseDailyListBloc = BlocProvider.of<ExcerciseDailyListBloc>(context);
    final daySelectorBloc = BlocProvider.of<DaySelectorBloc>(context);
    return MaterialPageRoute(
      builder: (_) {
        return MultiBlocProvider(
          providers: [
            BlocProvider(
              create: (context) => AddExcerciseLogBloc(
                daySelectorBloc: daySelectorBloc,
                activityRepository: RepositoryProvider.of<ActivityRepository>(context),
                authenticationBloc: BlocProvider.of<AuthenticationBloc>(context),
              ),
            ),
            BlocProvider.value(
              value: excerciseDailyListBloc,
            ),
          ],
          child: AddExcerciseLogView(),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Excercise Log'),
        actions: [
          IconButton(
            icon: const Icon(Icons.check),
            onPressed: () {
              BlocProvider.of<AddExcerciseLogBloc>(context).add(AddExcerciseLogFormSubmit());
            },
          ),
        ],
      ),
      body: BlocConsumer<AddExcerciseLogBloc, AddExcerciseLogState>(
        listener: (context, state) {
          if (state.status.isSubmissionSuccess) {
            if (state.mode == FormMode.add) {
              BlocProvider.of<ExcerciseDailyListBloc>(context).add(ExcerciseDailyListLogAdded(state.excerciseLog));
            } else {
              BlocProvider.of<ExcerciseDailyListBloc>(context).add(ExcerciseDailyListLogUpdated(state.excerciseLog));
            }
            Navigator.of(context).pop();
            ScaffoldMessenger.maybeOf(context)?.showSnackBar(SnackBar(content: Text('Excercise added successfully')));
          } else if (state.status.isSubmissionFailure) {
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error occured')));
          }
        },
        builder: (context, state) {
          if (state.status.isSubmissionInProgress) {
            return Center(
              child: const CircularProgressIndicator(),
            );
          }
          return ListView(
            physics: const ClampingScrollPhysics(),
            children: [
              _wrappedPadding(const _ExcerciseNameInput()),
              const _DurationInput(),
              _wrappedPadding(const IntensityInput()),
              _wrappedPadding(const _CaloriesInput()),
              _wrappedPadding(const _TimeInput()),
              _wrappedPadding(const _DateInput()),
              _wrappedPadding(const _ExcerciseTypeInput()),
            ],
          );
        },
      ),
    );
  }

  Widget _wrappedPadding(Widget child) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: child,
    );
  }
}

class _DurationInput extends StatelessWidget {
  const _DurationInput({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AddExcerciseLogBloc, AddExcerciseLogState>(
      builder: (context, state) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 20, top: 6),
              child: Text(
                'Duration:',
                style: TextStyle(
                  fontWeight: FontWeight.w500,
                  fontSize: 18,
                ),
              ),
            ),
            const SizedBox(height: 7),
            DurationSelector(
              duration: state.duration.value,
              onValueUpdated: (minutes) {
                BlocProvider.of<AddExcerciseLogBloc>(context).add(AddExcerciseLogDurationUpdated(minutes));
              },
            ),
          ],
        );
      },
    );
  }
}

class _ExcerciseNameInput extends StatelessWidget {
  const _ExcerciseNameInput({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AddExcerciseLogBloc, AddExcerciseLogState>(
      builder: (context, state) {
        return TextFormField(
          initialValue: state.name.value,
          decoration: InputDecoration(
            errorText: state.name.invalid ? 'Invalid' : null,
            labelText: 'Excercise name',
          ),
          onChanged: (val) => BlocProvider.of<AddExcerciseLogBloc>(context).add(AddExcerciseLogNameUpdated(val)),
        );
      },
    );
  }
}

class _CaloriesInput extends StatelessWidget {
  const _CaloriesInput({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AddExcerciseLogBloc, AddExcerciseLogState>(
      builder: (context, state) {
        return RowInputField(
          keyboardType: TextInputType.number,
          initialValue: state.calories.value,
          onChanged: (value) {
            BlocProvider.of<AddExcerciseLogBloc>(context).add(AddExcerciseLogCaloriesUpdated(value));
          },
          unit: 'cal',
          title: 'Calories',
        );
      },
    );
  }
}

class _TimeInput extends StatelessWidget {
  const _TimeInput({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AddExcerciseLogBloc, AddExcerciseLogState>(
      builder: (context, state) {
        return ListTile(
          contentPadding: EdgeInsets.zero,
          title: Text('Start time: '),
          trailing: Text('${state.time.value.hour}:${state.time.value.minute}'),
          onTap: () async {
            FocusScope.of(context).unfocus();
            TimeOfDay? time = await showTimePicker(
              context: context,
              initialTime: state.time.value,
              builder: (BuildContext context, Widget? child) {
                return MediaQuery(
                  data: MediaQuery.of(context).copyWith(alwaysUse24HourFormat: true),
                  child: child!,
                );
              },
            );
            BlocProvider.of<AddExcerciseLogBloc>(context).add(AddExcerciseLogTimeUpdated(time));
          },
        );
      },
    );
  }
}

class _DateInput extends StatelessWidget {
  const _DateInput({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AddExcerciseLogBloc, AddExcerciseLogState>(
      builder: (context, state) {
        return ListTile(
          contentPadding: EdgeInsets.zero,
          title: Text('Date: '),
          trailing: Text(
            DateFormat('dd.MMMM.yyyy').format(state.date.value),
          ),
          onTap: () async {
            FocusScope.of(context).unfocus();

            DateTime? date = await showDatePicker(
              context: context,
              initialDate: state.date.value,
              firstDate: BlocProvider.of<AuthenticationBloc>(context).state.user!.dateJoined!,
              lastDate: DateTime.now(),
            );

            BlocProvider.of<AddExcerciseLogBloc>(context).add(AddExcerciseLogDateUpdated(date));
          },
        );
      },
    );
  }
}

class _ExcerciseTypeInput extends StatelessWidget {
  const _ExcerciseTypeInput({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    return BlocBuilder<AddExcerciseLogBloc, AddExcerciseLogState>(
      builder: (context, state) {
        return ListTile(
          contentPadding: EdgeInsets.zero,
          title: Text('Excercise Type: '),
          trailing: Text(describeEnum(state.type.value)),
          onTap: () async {
            FocusScope.of(context).unfocus();

            ExcerciseType? type = await showModalBottomSheet<ExcerciseType?>(
              context: context,
              builder: (_) {
                return Container(
                  height: size.height * 0.5,
                  child: ExcerciseLogBottomSheet(
                    itemCount: ExcerciseType.values.length,
                    itemBuilder: (context, index) {
                      final item = ExcerciseType.values[index];
                      final isSelected = item == state.type.value;

                      return ListTile(
                        title: Text(
                          describeEnum(item),
                          style: TextStyle(
                            color: isSelected ? Colors.blue : Colors.black,
                          ),
                        ),
                        onTap: () {
                          Navigator.of(context).pop(item);
                        },
                      );
                    },
                  ),
                );
              },
            );

            BlocProvider.of<AddExcerciseLogBloc>(context).add(AddExcerciseLogTypeUpdated(type));
          },
        );
      },
    );
  }
}
