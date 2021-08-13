import 'package:flutter/material.dart';

class ExcerciseNameSearchDelegate extends SearchDelegate {
// TODO in the future

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        onPressed: () {
          close(context, query);
        },
        icon: const Icon(Icons.check),
      ),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.close),
      onPressed: () {
        Navigator.of(context).pop();
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    return ListView(
      children: [],
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return ListView();
  }
}
