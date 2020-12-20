import 'package:flutter/cupertino.dart';

class TimeLimitPicker extends StatelessWidget {
  final Function setTime;

  TimeLimitPicker({this.setTime});

  @override
  Widget build(BuildContext context) {
    return Container(
      child: CupertinoTimerPicker(
        mode: CupertinoTimerPickerMode.hm,
        onTimerDurationChanged: setTime
      ),
      height: 100,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(10)),
        color: Color(0x20000000)
      ),
    );
  }
}
