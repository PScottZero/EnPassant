import 'package:flutter/cupertino.dart';

class TimeLimitPicker extends StatelessWidget {
  final Function setTime;

  TimeLimitPicker({this.setTime});

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      Text('Time Limit', style: TextStyle(fontSize: 20)),
      SizedBox(height: 10),
      Container(
        child: CupertinoTimerPicker(
          mode: CupertinoTimerPickerMode.hm,
          onTimerDurationChanged: setTime
        ),
        height: 100,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(10)),
          color: Color(0x20000000)
        ),
      ),
    ]);
  }
}
