import 'package:en_passant/views/components/text_variable.dart';
import 'package:en_passant/views/view_constants.dart';
import 'package:flutter/cupertino.dart';

class Picker extends StatelessWidget {
  final List<String> options;
  final int selectionIndex;
  final Function setFunc;

  Picker(
      {@required this.options,
      @required this.selectionIndex,
      @required this.setFunc});

  @override
  Widget build(BuildContext context) {
    return CupertinoPicker(
      scrollController: FixedExtentScrollController(
        initialItem: selectionIndex,
      ),
      selectionOverlay: CupertinoPickerDefaultSelectionOverlay(
        background: ViewConstants.BACKGROUND_COLOR,
        capLeftEdge: false,
        capRightEdge: false,
      ),
      itemExtent: ViewConstants.PICKER_ITEM_EXTENT,
      onSelectedItemChanged: setFunc,
      children: options
          .map(
            (option) => Container(
              padding: EdgeInsets.all(
                ViewConstants.PADDING_SMALL,
              ),
              child: TextRegular(option),
            ),
          )
          .toList(),
    );
  }
}
