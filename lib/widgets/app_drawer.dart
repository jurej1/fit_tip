import 'package:fit_tip/weight/view/weight_history_view.dart';
import 'package:flutter/material.dart';

class AppDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Container(
        child: Column(
          children: [
            const SizedBox(height: 50),
            ListTile(
              leading: const Icon(Icons.ac_unit),
              title: Text('Weight tracking'),
              onTap: () {
                Navigator.of(context).pushNamed(WeightHistoryView.routeName);
              },
            ),
          ],
        ),
      ),
    );
  }
}
