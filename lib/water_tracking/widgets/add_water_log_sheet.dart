import 'package:fit_tip/authentication/authentication.dart';
import 'package:fit_tip/shared/blocs/day_selector/day_selector_bloc.dart';
import 'package:fit_tip/water_tracking/blocs/blocs.dart';
import 'package:fit_tip/water_tracking/blocs/water_sheet_tile/water_sheet_tile_bloc.dart';
import 'package:fit_tip/water_tracking/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:water_repository/water_repository.dart';

class AddWaterLogSheet extends StatelessWidget {
  static const _cups = WaterCups.values;

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;

    return Container(
      height: size.height * 0.25,
      child: Column(
        children: [
          const SizedBox(height: 10),
          Container(
            height: 7,
            width: 60,
            decoration: BoxDecoration(borderRadius: BorderRadius.circular(10), color: Colors.grey),
          ),
          const SizedBox(height: 15),
          Expanded(
            child: ListView.separated(
              separatorBuilder: (context, index) {
                return const SizedBox(width: 15);
              },
              shrinkWrap: true,
              itemCount: _cups.length,
              physics: const ClampingScrollPhysics(),
              padding: const EdgeInsets.symmetric(horizontal: 15),
              scrollDirection: Axis.horizontal,
              itemBuilder: (context, index) {
                final item = _cups[index];

                return MultiBlocProvider(
                  providers: [
                    BlocProvider<WaterSheetTileBloc>(
                      create: (context) => WaterSheetTileBloc(
                        cup: item,
                        authenticationBloc: BlocProvider.of<AuthenticationBloc>(context),
                        waterRepository: RepositoryProvider.of<WaterRepository>(context),
                        waterLogFocusedDayBloc: BlocProvider.of<DaySelectorBloc>(context),
                      ),
                    ),
                  ],
                  child: WaterCupCard(),
                );
              },
            ),
          ),
          const SizedBox(height: 30),
        ],
      ),
    );
  }
}
