import 'package:fit_tip/authentication/blocs/blocs.dart';
import 'package:fit_tip/water_tracking/blocs/blocs.dart';
import 'package:fit_tip/water_tracking/widgets/water_log_grid_tile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:water_repository/water_repository.dart';

class WaterLogGrid extends StatelessWidget {
  final List<WaterLog> waterLogs;

  const WaterLogGrid({Key? key, required this.waterLogs}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (waterLogs.isEmpty) {
      return Container();
    }

    return GridView.builder(
      padding: EdgeInsets.all(10),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 4,
        mainAxisSpacing: 10,
        crossAxisSpacing: 10,
        childAspectRatio: 2.5 / 3,
      ),
      shrinkWrap: true,
      physics: const ClampingScrollPhysics(),
      itemCount: waterLogs.length,
      itemBuilder: (context, index) {
        final item = waterLogs[index];

        return BlocProvider<WaterGridTileBloc>(
          create: (context) => WaterGridTileBloc(
            waterLog: item,
            authenticationBloc: BlocProvider.of<AuthenticationBloc>(context),
            waterRepository: RepositoryProvider.of<WaterRepository>(context),
          ),
          child: WaterLogGridTile(),
        );
      },
    );
  }
}
