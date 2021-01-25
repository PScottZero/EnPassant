import 'package:flutter/cupertino.dart';

class RoundedIconButton extends StatelessWidget {
  final IconData icon;
  final Function onPressed;

  RoundedIconButton(this.icon, {@required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Container(
      child: CupertinoButton(
        padding: EdgeInsets.zero,
        color: Color(0x20000000),
        child: Icon(icon, color: Color(0xffffffff)),
        borderRadius: BorderRadius.all(Radius.circular(15)),
        onPressed: onPressed,
      ),
      width: double.infinity,
      height: 60,
    );
  }
}
