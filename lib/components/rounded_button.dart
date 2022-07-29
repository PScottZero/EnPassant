import 'package:flutter/cupertino.dart';

import '../constants/view_constants.dart';
import 'text_variable.dart';

class RoundedButton extends StatelessWidget {
  final String label;
  final Function() onPressed;

  RoundedButton(this.label, {required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Container(
      child: CupertinoButton(
        padding: EdgeInsets.zero,
        color: ViewConstants.backgroundColor,
        child: TextRegular(label),
        borderRadius: BorderRadius.circular(
          ViewConstants.borderRadius,
        ),
        onPressed: onPressed,
      ),
      width: double.infinity,
      height: ViewConstants.buttonHeight,
    );
  }
}
