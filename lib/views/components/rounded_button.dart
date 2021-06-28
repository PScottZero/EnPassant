import 'package:en_passant/views/components/text_variable.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../view_constants.dart';

class RoundedButton extends StatelessWidget {
  final String label;
  final Function onPressed;

  RoundedButton(this.label, {@required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Container(
      child: CupertinoButton(
        padding: EdgeInsets.zero,
        color: ViewConstants.BACKGROUND_COLOR,
        child: TextRegular(label),
        borderRadius: BorderRadius.circular(
          ViewConstants.BORDER_RADIUS,
        ),
        onPressed: onPressed,
      ),
      width: double.infinity,
      height: ViewConstants.BUTTON_HEIGHT,
    );
  }
}
