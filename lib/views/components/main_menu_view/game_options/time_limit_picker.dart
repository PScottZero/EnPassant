import 'package:en_passant/views/components/main_menu_view/game_options/picker.dart';
import 'package:flutter/cupertino.dart';

class TimeLimitPicker extends StatelessWidget {
  final int selectedTime;
  final Function setTime;

  TimeLimitPicker({this.selectedTime, this.setTime});

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
    return Picker<int>(
      label: 'Time Limit',
      options: timeOptions,
      selection: selectedTime,
      setFunc: setTime,
    );
  }
}
