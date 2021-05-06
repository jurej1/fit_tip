import 'package:authentication_repository/authentication_repository.dart';
import 'package:fit_tip/authentication/authentication.dart';
import 'package:fit_tip/weight/weight.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:weight_repository/weight_repository.dart' as rep;

class WeightTile extends StatelessWidget {
  final rep.Weight weight;

  const WeightTile({Key? key, required this.weight}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocListener<WeightTileBloc, WeightTileState>(
      listener: (context, state) async {
        if (state is WeightTileDeletedSuccessfully) {
          BlocProvider.of<WeightHistoryBloc>(context).add(WeightHistoryDelete(state.weight));
          await ScaffoldMessenger.of(context)
              .showSnackBar(
                SnackBar(
                  content: Text('Deleting in progress'),
                ),
              )
              .closed;
        }
      },
      child: Dismissible(
        onDismissed: (direction) {
          BlocProvider.of<WeightTileBloc>(context).add(WeightTileDeleteRequested());
        },
        key: ValueKey(weight),
        background: _dismissibleBackground(),
        secondaryBackground: _dismissibleBackground(),
        child: ListTile(
          leading: Text(
            weight.weight!.toDouble().toString() +
                ' ' +
                MeasurmentSystemConverter.meaSystToWeightUnit(BlocProvider.of<MeasurmentSystemBloc>(context).state),
          ),
          trailing: weight.date != null ? Text(DateFormat('HH:mm - d.MMM.yyyy').format(weight.date!)) : null,
        ),
      ),
    );
  }

  Widget _dismissibleBackground() {
    return Container(
      color: Colors.red,
      alignment: Alignment.centerRight,
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: _deleteIcon(),
    );
  }

  Widget _deleteIcon() {
    return const Icon(
      Icons.delete,
      color: Colors.white,
    );
  }
}
