import 'package:fit_tip/fitness_blogs/blocs/blocs.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AboutAuthorDisplayer extends StatelessWidget {
  const AboutAuthorDisplayer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AboutAuthorBloc, AboutAuthorState>(
      builder: (context, state) {
        if (state is AboutAuthorLoading) {
          return Container(
            height: 100,
            child: const Center(
              child: const CircularProgressIndicator(),
            ),
          );
        } else if (state is AboutAuthorLoadSuccess) {
          final user = state.author;
          return Material(
            color: Colors.grey.shade200,
            borderRadius: BorderRadius.circular(12),
            child: InkWell(
              borderRadius: BorderRadius.circular(12),
              onTap: () {},
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      user.displayName ?? 'Unknown',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                    Text(user.introduction ?? ''),
                  ],
                ),
              ),
            ),
          );
        }

        return Container();
      },
    );
  }
}
