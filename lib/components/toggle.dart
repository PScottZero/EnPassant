import 'package:flutter/cupertino.dart';

import '../constants/view_constants.dart';
import 'text_variable.dart';

class Toggle extends StatelessWidget {
  final String label;
  final bool toggle;
  final Function(bool) setFunc;

  Toggle({
    required this.label,
    required this.toggle,
    required this.setFunc,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: ViewConstants.TOGGLE_HEIGHT,
      child: Row(
        children: [
          TextRegular(label),
          Spacer(),
          CupertinoSwitch(
            value: toggle,
            onChanged: setFunc,
          ),
        ],
      ),
    );
  }
}
