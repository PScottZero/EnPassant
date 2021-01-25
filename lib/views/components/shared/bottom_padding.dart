import 'dart:io';
import 'dart:math';

import 'package:flutter/cupertino.dart';

class BottomPadding extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: Platform.isAndroid
          ? max(MediaQuery.of(context).viewInsets.bottom,
              MediaQuery.of(context).padding.bottom)
          : 0,
    );
  }
}
