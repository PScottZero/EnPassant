import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class RoundedButton extends StatelessWidget {
  final String label;
  final Function onPressed;

  RoundedButton(this.label, {@required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Container(
      child: CupertinoButton(
        padding: EdgeInsets.zero,
        color: Color(0x20000000),
        child: Text(
          label,
          style: TextStyle(
            color: Colors.white,
            fontSize: 24,
          ),
        ),
        borderRadius: BorderRadius.all(Radius.circular(15)),
        onPressed: onPressed,
      ),
      width: double.infinity,
      height: 60,
    );
  }
}
