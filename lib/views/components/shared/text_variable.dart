import 'package:flutter/cupertino.dart';

class TextDefault extends StatelessWidget {
  final String text;
  final Color color;

  TextDefault(this.text, {this.color = CupertinoColors.white});

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: TextStyle(
        fontSize: 16,
        fontFamily: 'Jura',
        color: color,
      ),
    );
  }
}

class TextSmall extends StatelessWidget {
  final String text;

  TextSmall(this.text);

  @override
  Widget build(BuildContext context) {
    return Text(text, style: TextStyle(fontSize: 20));
  }
}

class TextRegular extends StatelessWidget {
  final String text;

  TextRegular(this.text);

  @override
  Widget build(BuildContext context) {
    return Text(text, style: TextStyle(fontSize: 24));
  }
}

class TextLarge extends StatelessWidget {
  final String text;

  TextLarge(this.text);

  @override
  Widget build(BuildContext context) {
    return Text(text, style: TextStyle(fontSize: 36));
  }
}
