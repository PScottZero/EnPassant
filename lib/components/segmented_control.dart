import 'package:flutter/cupertino.dart';

import '../constants/view_constants.dart';
import 'gap.dart';
import 'text_variable.dart';

class SegmentedControl<T> extends StatelessWidget {
  final String label;
  final Map<T, Text> options;
  final T selection;
  final Function setFunc;

  SegmentedControl({
    required this.label,
    required this.options,
    required this.selection,
    required this.setFunc,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TextSmall(label),
        GapColumnSmall(),
        ClipRRect(
          borderRadius: BorderRadius.circular(
            ViewConstants.borderRadius,
          ),
          child: Container(
            child: CupertinoTheme(
              data: CupertinoThemeData(
                textTheme: CupertinoTextThemeData(
                  textStyle: TextStyle(
                    fontFamily: 'Jura',
                    fontSize: ViewConstants.textSegmentedControl,
                  ),
                ),
              ),
              child: CupertinoSlidingSegmentedControl<T>(
                children: options,
                groupValue: selection,
                onValueChanged: (T? val) => setFunc(val),
                padding: EdgeInsets.fromLTRB(
                  ViewConstants.segmentedControlPaddingLR,
                  ViewConstants.segmentedControlPaddingTB,
                  ViewConstants.segmentedControlPaddingLR,
                  ViewConstants.segmentedControlPaddingTB,
                ),
                thumbColor: ViewConstants.pickerThumbColor,
                backgroundColor: ViewConstants.backgroundColor,
              ),
            ),
            width: double.infinity,
          ),
        ),
      ],
    );
  }
}
