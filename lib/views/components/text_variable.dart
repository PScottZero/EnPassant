import 'package:flutter/cupertino.dart';

import '../view_constants.dart';

class TextDefault extends StatelessWidget {
  final String text;
  final Color color;
  final double fontSize;

  TextDefault(
    this.text, {
    this.fontSize = ViewConstants.TEXT_DIALOG,
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
      : super(text, fontSize: ViewConstants.TEXT_SMALL, color: color);
}

class TextRegular extends TextDefault {
  TextRegular(String text, {Color color = CupertinoColors.white})
      : super(text, fontSize: ViewConstants.TEXT_REGULAR, color: color);
}

class TextLarge extends TextDefault {
  TextLarge(String text, {Color color = CupertinoColors.white})
      : super(text, fontSize: ViewConstants.TEXT_LARGE, color: color);
}
