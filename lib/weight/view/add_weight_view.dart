import 'package:fit_tip/weight/blocs/add_weight_form/add_weight_form_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:formz/formz.dart';

class AddWeightView extends StatelessWidget {
  static const routeName = 'add_weight_view';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          _SubmitButton(),
        ],
      ),
      body: ListView(
        children: [
          _WeightInput(),
        ],
      ),
    );
  }
}

class _WeightInput extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Text('Weight'),
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
          children: [
            Text('Date'),
            TextButton(
              child: Text(DateFormat('dd.MMMMM.yyyy').format(state.dateAdded.value)),
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

class _SubmitButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AddWeightFormBloc, AddWeightFormState>(
      builder: (context, state) {
        if (state.status.isSubmissionInProgress) {
          return CircularProgressIndicator();
        }
        return TextButton(
          child: const Text('Submit'),
          onPressed: () => BlocProvider.of<AddWeightFormBloc>(context).add(AddWeightFormSubit()),
        );
      },
    );
  }
}
