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
                    fontSize: ViewConstants.TEXT_SEGMENTED_CONTROL,
                  ),
                ),
              ),
              child: CupertinoSlidingSegmentedControl<T>(
                children: options,
                groupValue: selection,
                onValueChanged: (T? val) => setFunc(val),
                padding: EdgeInsets.fromLTRB(
                  ViewConstants.SEGMENTED_CONTROL_PADDING_LR,
                  ViewConstants.SEGMENTED_CONTROL_PADDING_TB,
                  ViewConstants.SEGMENTED_CONTROL_PADDING_LR,
                  ViewConstants.SEGMENTED_CONTROL_PADDING_TB,
                ),
                thumbColor: ViewConstants.PICKER_THUMB_COLOR,
                backgroundColor: ViewConstants.BACKGROUND_COLOR,
              ),
            ),
            width: double.infinity,
          ),
        ),
      ],
    );
  }
}
