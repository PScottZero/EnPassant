import 'package:flutter/cupertino.dart';

import 'segmented_control.dart';

class TimeLimitPicker extends StatelessWidget {
  final int selectedTime;
  final Function setTime;

  TimeLimitPicker({required this.selectedTime, required this.setTime});

  final Map<int, Text> timeOptions = const <int, Text>{
    0: Text('None'),
    15: Text('15m'),
    30: Text('30m'),
    60: Text('1h'),
    90: Text('1.5h'),
    120: Text('2h')
  };

  @override
  Widget build(BuildContext context) {
    return SegmentedControl<int>(
      label: 'Time Limit',
      options: timeOptions,
      selection: selectedTime,
      setFunc: setTime,
    );
  }
}