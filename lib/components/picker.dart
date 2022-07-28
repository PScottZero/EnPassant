import 'package:flutter/cupertino.dart';

import '../constants/view_constants.dart';
import 'text_variable.dart';

class Picker extends StatelessWidget {
  final List<String> options;
  final int selectionIndex;
  final Function(int) setFunc;

  Picker({
    required this.options,
    required this.selectionIndex,
    required this.setFunc,
  });

  @override
  Widget build(BuildContext context) {
    return CupertinoPicker(
      scrollController: FixedExtentScrollController(
        initialItem: selectionIndex,
      ),
      selectionOverlay: CupertinoPickerDefaultSelectionOverlay(
        background: ViewConstants.BACKGROUND_COLOR,
      ),
      itemExtent: ViewConstants.pickerItemExtent,
      onSelectedItemChanged: setFunc,
      children: options
          .map(
            (option) => Container(
              padding: EdgeInsets.all(
                ViewConstants.smallPadding,
              ),
              child: TextRegular(option),
            ),
          )
          .toList(),
    );
  }
}
