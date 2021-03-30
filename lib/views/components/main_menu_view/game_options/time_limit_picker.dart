import 'package:en_passant/views/components/shared/text_variable.dart';
import 'package:flutter/cupertino.dart';

class TimeLimitPicker extends StatelessWidget {
  final Duration selectedTime;
  final Function setTime;

  TimeLimitPicker({this.selectedTime, this.setTime});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TextSmall('Time Limit'),
        SizedBox(height: 10),
        Container(
          child: CupertinoTimerPicker(
            initialTimerDuration: selectedTime,
            mode: CupertinoTimerPickerMode.hm,
            onTimerDurationChanged: setTime,
            backgroundColor: Color(0x00000000),
            alignment: Alignment.topCenter,
          ),
          height: 120,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(15)),
            color: Color(0x20000000),
          ),
        ),
      ],
    );
  }
}
