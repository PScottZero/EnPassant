import 'package:flutter/cupertino.dart';

import '../../shared/text_variable.dart';

class Picker<T> extends StatelessWidget {
  final String label;
  final Map<T, Text> options;
  final T selection;
  final Function setFunc;

  Picker({this.label, this.options, this.selection, this.setFunc});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TextSmall(label),
        SizedBox(height: 10),
        Container(
          child: CupertinoTheme(
            data: CupertinoThemeData(
              textTheme: CupertinoTextThemeData(
                textStyle: TextStyle(fontFamily: 'Jura', fontSize: 8),
              ),
            ),
            child: CupertinoSlidingSegmentedControl<T>(
              children: options,
              groupValue: selection,
              onValueChanged: (T val) {
                setFunc(val);
              },
              thumbColor: Color(0x88FFFFFF),
              backgroundColor: Color(0x20000000),
            ),
          ),
          width: double.infinity,
        )
      ],
    );
  }
}
