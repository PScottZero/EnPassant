import 'package:flutter/cupertino.dart';

import '../view_constants.dart';

class RoundedBackground extends StatelessWidget {
  final Widget child;
  final double height;

  RoundedBackground(this.child, {this.height});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(
          ViewConstants.BORDER_RADIUS,
        ),
        color: ViewConstants.BACKGROUND_COLOR,
      ),
      child: child,
    );
  }
}
