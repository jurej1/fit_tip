import 'package:fit_tip/excercise_tracking/blocs/blocs.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AddExcerciseLogView extends StatelessWidget {
  const AddExcerciseLogView({Key? key}) : super(key: key);

  static route(BuildContext context) {
    final excerciseDailyListBloc = BlocProvider.of<ExcerciseDailyListBloc>(context);
    return MaterialPageRoute(
      builder: (_) {
        return MultiBlocProvider(
          providers: [
            BlocProvider(
              create: (context) => AddExcerciseLogBloc(),
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
      ),
      body: Column(
        children: [
          DurationSelector(),
          BlocBuilder<AddExcerciseLogBloc, AddExcerciseLogState>(
            builder: (context, state) {
              return Text('x = ${state.offset};');
            },
          ),
        ],
      ),
    );
  }
}

class DurationSelector extends StatefulWidget {
  const DurationSelector({Key? key}) : super(key: key);

  @override
  _DurationSelectorState createState() => _DurationSelectorState();
}

class _DurationSelectorState extends State<DurationSelector> {
  late final ScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    _scrollController.addListener(() {
      BlocProvider.of<AddExcerciseLogBloc>(context).add(AddExcerciseLogDurationUpdated(_scrollController.offset));
    });
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    return Container(
      width: size.width,
      height: 200,
      child: ListView.separated(
        controller: _scrollController,
        scrollDirection: Axis.horizontal,
        itemBuilder: (context, index) {
          return Container(
            height: 200,
            width: 20,
            color: Colors.red,
          );
        },
        separatorBuilder: (context, index) {
          return SizedBox(
            width: 20,
          );
        },
        itemCount: 1440,
      ),
    );
  }
}
