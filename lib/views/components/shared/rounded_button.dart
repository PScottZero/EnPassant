import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class RoundedButton extends StatelessWidget {
  final String label;
  final Function onPressed;
  final Color color;

  RoundedButton({this.label, this.onPressed, this.color = const Color(0x20000000)});

  @override
  Widget build(BuildContext context) {
    return Container(
      child: CupertinoButton(
        padding: EdgeInsets.zero,
        color: color,
        child: Text(
          label, 
          style: TextStyle(
            color: Colors.white,
            fontSize: 20
          )
        ),
        borderRadius: BorderRadius.all(Radius.circular(15)),
        onPressed: onPressed,
      ),
      width: double.infinity,
      height: 60
    );
  }
}
