import 'package:flutter/cupertino.dart';

import '../constants/view_constants.dart';
import 'text_variable.dart';

class TimerWidget extends StatelessWidget {
  final Duration timeLeft;
  final Color color;

  const TimerWidget({
    Key? key,
    required this.timeLeft,
    required this.color,
  }) : super(key: key);

  String _durationToString(Duration duration) {
    if (duration.inHours > 0) {
      String hours = duration.inHours.toString();
      String minutes =
          duration.inMinutes.remainder(60).toString().padLeft(2, '0');
      String seconds =
          duration.inSeconds.remainder(60).toString().padLeft(2, '0');
      return '$hours:$minutes:$seconds';
    } else if (duration.inMinutes > 0) {
      String minutes = duration.inMinutes.toString();
      String seconds =
          duration.inSeconds.remainder(60).toString().padLeft(2, '0');
      return '$minutes:$seconds';
    } else {
      String seconds = duration.inSeconds.toString();
      return '$seconds';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        height: ViewConstants.buttonHeight,
        child: Center(child: TextRegular(_durationToString(timeLeft))),
        decoration: BoxDecoration(
          border: Border.all(
            color: color,
            width: ViewConstants.smallBorderWidth,
          ),
          borderRadius: BorderRadius.circular(ViewConstants.borderRadius),
          color: ViewConstants.backgroundColor,
        ),
      ),
    );
  }
}
