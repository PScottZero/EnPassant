import 'package:en_passant/views/view_constants.dart';
import 'package:flutter/cupertino.dart';

class Gap extends StatelessWidget {
  final double gapSize;
  final bool isHorizontal;

  Gap(this.gapSize, this.isHorizontal);

  @override
  Widget build(BuildContext context) {
    return isHorizontal ? SizedBox(height: gapSize) : SizedBox(width: gapSize);
  }
}

class GapColumnSmall extends Gap {
  GapColumnSmall() : super(ViewConstants.GAP_SMALL, true);
}

class GapRowSmall extends Gap {
  GapRowSmall() : super(ViewConstants.GAP_SMALL, false);
}

class GapColumnLarge extends Gap {
  GapColumnLarge() : super(ViewConstants.GAP_LARGE, true);
}
