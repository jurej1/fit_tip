import 'package:authentication_repository/authentication_repository.dart';
import 'package:fit_tip/authentication/authentication.dart';
import 'package:fit_tip/weight_tracking/weight.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:formz/formz.dart';

class AddWeightView extends StatelessWidget {
  static const routeName = 'add_weight_view';

  @override
  Widget build(BuildContext context) {
    return BlocListener<AddWeightFormBloc, AddWeightFormState>(
      listener: (context, state) {
        if (state.status.isSubmissionSuccess) {
          BlocProvider.of<WeightHistoryBloc>(context).add(WeightHistoryAdded(state.weightModel));
          Navigator.of(context).pop();
        }
      },
      child: Scaffold(
        appBar: AppBar(
          actions: [
            _SubmitButton(),
          ],
        ),
        body: ListView(
          padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 20),
          children: [
            _WeightInput(),
            _DateInput(),
            _TimeInput(),
          ],
        ),
      ),
    );
  }
}

class _WeightInput extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text('Weight in ${MeasurmentSystemConverter.meaSystToWeightUnit(BlocProvider.of<MeasurmentSystemBloc>(context).state)}'),
        BlocBuilder<AddWeightFormBloc, AddWeightFormState>(
          builder: (context, state) {
            return SizedBox(
              width: 11 * 4,
              child: TextFormField(
                textAlign: TextAlign.center,
                onChanged: (val) => BlocProvider.of<AddWeightFormBloc>(context).add(AddWeightWeightChanged(val)),
              ),
            );
          },
        ),
      ],
    );
  }
}

class _DateInput extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AddWeightFormBloc, AddWeightFormState>(
      builder: (context, state) {
        return Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('Date'),
            TextButton(
              style: ButtonStyle(
                padding: MaterialStateProperty.all(EdgeInsets.zero),
              ),
              child: Text(DateFormat('dd.MMMM.yyyy').format(state.dateAdded.value)),
              onPressed: () async {
                final date = await showDatePicker(
                  context: context,
                  initialDate: DateTime.now(),
                  firstDate: DateTime.now().subtract(const Duration(days: 365 * 5)),
                  lastDate: DateTime.now(),
                );

                BlocProvider.of<AddWeightFormBloc>(context).add(AddWeightDateChanged(date));
              },
            ),
          ],
        );
      },
    );
  }
}

class _TimeInput extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AddWeightFormBloc, AddWeightFormState>(
      builder: (context, state) {
        return Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('Time'),
            TextButton(
              style: ButtonStyle(
                padding: MaterialStateProperty.all(EdgeInsets.zero),
              ),
              child: Text(state.timeAdded.value.format(context)),
              onPressed: () async {
                final timeOfDay = await showTimePicker(
                  context: context,
                  initialTime: TimeOfDay.now(),
                );

                BlocProvider.of<AddWeightFormBloc>(context).add(AddWeightTimeChanged(timeOfDay));
              },
            ),
          ],
        );
      },
    );
  }
}

class _SubmitButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AddWeightFormBloc, AddWeightFormState>(
      builder: (context, state) {
        final isLoading = state.status.isSubmissionInProgress;

        return TextButton(
          child: isLoading ? CircularProgressIndicator() : Text('Add', style: TextStyle(color: Colors.white)),
          onPressed: isLoading ? () {} : () => BlocProvider.of<AddWeightFormBloc>(context).add(AddWeightFormSubit()),
        );
      },
    );
  }
}