import 'package:fit_tip/fitness_tracking/widgets/widgets.dart';
import 'package:flutter/material.dart';

class HeightFormView extends StatefulWidget {
  const HeightFormView({Key? key}) : super(key: key);

  static MaterialPageRoute<int?> route(BuildContext context) {
    return MaterialPageRoute<int?>(
      builder: (_) {
        return HeightFormView();
      },
    );
  }

  @override
  _HeightFormViewState createState() => _HeightFormViewState();
}

class _HeightFormViewState extends State<HeightFormView> {
  int value = 160;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Height'),
        actions: [
          IconButton(
            icon: Icon(Icons.check),
            onPressed: () {
              Navigator.of(context).pop<int?>(value);
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(10),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Height (cm)'),
                DraggableValueSelector.route(
                  itemHeight: 20,
                  onValueUpdated: (val) {
                    setState(() {
                      value = val;
                    });
                  },
                  itemCount: 250,
                  height: 100,
                  focusedValue: value,
                  width: 40,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
