import 'package:flutter/cupertino.dart';

import '../constants/view_constants.dart';

class RoundedBackground extends StatelessWidget {
  final Widget child;
  final double height;

  RoundedBackground({required this.child, required this.height});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(
          ViewConstants.borderRadius,
        ),
        color: ViewConstants.backgroundColor,
      ),
      child: child,
    );
  }
}
