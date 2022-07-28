import 'package:flutter/cupertino.dart';

import '../constants/view_constants.dart';

class RoundedIconButton extends StatelessWidget {
  final IconData icon;
  final Function()? onPressed;

  RoundedIconButton(this.icon, {required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Container(
      child: CupertinoButton(
        padding: EdgeInsets.zero,
        color: ViewConstants.BACKGROUND_COLOR,
        child: Icon(icon, color: ViewConstants.WHITE),
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
