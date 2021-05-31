import 'package:fit_tip/water_tracking/water_tracking.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:water_repository/water_repository.dart';

class WaterCupCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 150,
      child: Material(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        elevation: 1.5,
        shadowColor: Colors.black26,
        color: Colors.blue,
        child: InkWell(
          borderRadius: BorderRadius.circular(10),
          onTap: () {
            BlocProvider.of<WaterSheetTileBloc>(context).add(WaterSheetTileAddWater());
          },
          child: BlocConsumer<WaterSheetTileBloc, WaterSheetTileState>(
            listener: (contex, state) {
              if (state.status == WaterSheetTileStatus.error) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Sorry but there was an error please try again later'),
                  ),
                );
              } else if (state.status == WaterSheetTileStatus.success) {
                Navigator.of(context).pop();
                BlocProvider.of<WaterLogDayBloc>(context).add(WaterLogAddede(state.waterLog!));
              }
            },
            builder: (context, state) {
              if (state.status == WaterSheetTileStatus.loading) {
                return const Center(
                  child: const CircularProgressIndicator(),
                );
              }

              return Container(
                child: Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        mapDrinkingCupSizeToString(state.cup.size),
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 24,
                        ),
                      ),
                      Text(state.cup.amount.toStringAsFixed(0) + 'ml'),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
