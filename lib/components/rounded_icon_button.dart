import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

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
        color: ViewConstants.backgroundColor,
        child: Icon(icon, color: Colors.white),
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
