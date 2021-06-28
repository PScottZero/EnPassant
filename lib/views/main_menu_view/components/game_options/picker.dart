import 'package:en_passant/views/components/text_variable.dart';
import 'package:en_passant/views/view_constants.dart';
import 'package:flutter/cupertino.dart';

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
        SizedBox(height: ViewConstants.SMALL_GAP),
        ClipRRect(
          borderRadius: BorderRadius.circular(ViewConstants.BORDER_RADIUS),
          child: Container(
            child: CupertinoTheme(
              data: CupertinoThemeData(
                textTheme: CupertinoTextThemeData(
                  textStyle: TextStyle(
                    fontFamily: ViewConstants.FONT_NAME,
                    fontSize: ViewConstants.TEXT_PICKER,
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
                  ViewConstants.PICKER_PADDING_LR,
                  ViewConstants.PICKER_PADDING_TB,
                  ViewConstants.PICKER_PADDING_LR,
                  ViewConstants.PICKER_PADDING_TB,
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
