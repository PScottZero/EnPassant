import 'package:en_passant/views/components/gap.dart';
import 'package:en_passant/views/components/text_variable.dart';
import 'package:en_passant/views/view_constants.dart';
import 'package:flutter/cupertino.dart';

class SegmentedControl<T> extends StatelessWidget {
  final String label;
  final Map<T, Text> options;
  final T selection;
  final Function setFunc;

  SegmentedControl({this.label, this.options, this.selection, this.setFunc});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TextSmall(label),
        GapColumnSmall(),
        ClipRRect(
          borderRadius: BorderRadius.circular(
            ViewConstants.BORDER_RADIUS,
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
                onValueChanged: (T val) {
                  setFunc(val);
                },
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
