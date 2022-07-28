import 'package:flutter/cupertino.dart';

import '../constants/view_constants.dart';

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
  GapColumnSmall() : super(ViewConstants.smallGap, true);
}

class GapRowSmall extends Gap {
  GapRowSmall() : super(ViewConstants.smallGap, false);
}

class GapColumnLarge extends Gap {
  GapColumnLarge() : super(ViewConstants.largeGap, true);
}
