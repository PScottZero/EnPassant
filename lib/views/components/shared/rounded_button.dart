import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class RoundedButton extends StatelessWidget {
  final String label;
  final Function onPressed;
  final bool disabled;

  RoundedButton({
    this.label,
    this.onPressed,
    this.disabled = false
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      child: CupertinoButton(
        disabledColor: Color(0x40FF0000),
        padding: EdgeInsets.zero,
        color: Color(0x20000000),
        child: Text(
          label, 
          style: TextStyle(
            color: Colors.white,
            fontSize: 24
          )
        ),
        borderRadius: BorderRadius.all(Radius.circular(15)),
        onPressed: disabled ? null : onPressed,
      ),
      width: double.infinity,
      height: 60
    );
  }
}
