import 'package:fit_tip/weight_tracking/blocs/blocs.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:weight_repository/weight_repository.dart';

import 'package:fit_tip/weight_tracking/widgets/widgets.dart';

class WeightHistoryList extends StatelessWidget {
  final List<Weight> weights;

  const WeightHistoryList({
    Key? key,
    required this.weights,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      physics: const ClampingScrollPhysics(),
      shrinkWrap: true,
      itemCount: weights.length,
      itemBuilder: (context, index) {
        final item = weights[index];
        return BlocProvider(
          create: (context) => WeightTileBloc(
            weightRepository: RepositoryProvider.of<WeightRepository>(context),
            weight: item,
          ),
          child: WeightTile(weight: item),
        );
      },
    );
  }
}
