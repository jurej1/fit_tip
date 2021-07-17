import 'package:fit_tip/fitness_tracking/blocs/blocs.dart';
import 'package:fit_tip/fitness_tracking/fitness_tracking.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AddWorkoutViewAppBar extends StatelessWidget with PreferredSizeWidget {
  const AddWorkoutViewAppBar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AddWorkoutViewCubit, AddWorkoutFormViewState>(
      builder: (context, state) {
        return AppBar(
          title: Text('Add workout'),
          actions: [
            IconButton(
              onPressed: () {
                FocusScope.of(context).unfocus();
                BlocProvider.of<AddWorkoutFormBloc>(context).add(AddWorkoutFormSubmitted());
              },
              icon: const Icon(Icons.check),
            ),
          ],
        );
      },
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);
}
