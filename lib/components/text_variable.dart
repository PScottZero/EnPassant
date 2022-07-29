import 'package:flutter/cupertino.dart';

import '../constants/view_constants.dart';

class TextDefault extends StatelessWidget {
  final String text;
  final Color color;
  final double fontSize;

  TextDefault(
    this.text, {
    this.fontSize = ViewConstants.textDialog,
    this.color = CupertinoColors.white,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: TextStyle(
        fontSize: fontSize,
        fontFamily: 'Jura',
        color: color,
      ),
    );
  }
}

class TextSmall extends TextDefault {
  TextSmall(String text, {Color color = CupertinoColors.white})
      : super(text, fontSize: ViewConstants.textSmall, color: color);
}

class TextRegular extends TextDefault {
  TextRegular(String text, {Color color = CupertinoColors.white})
      : super(text, fontSize: ViewConstants.textRegular, color: color);
}

class TextLarge extends TextDefault {
  TextLarge(String text, {Color color = CupertinoColors.white})
      : super(text, fontSize: ViewConstants.textLarge, color: color);
}
