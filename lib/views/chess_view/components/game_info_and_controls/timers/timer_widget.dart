import 'package:en_passant/views/components/text_variable.dart';
import 'package:en_passant/views/view_constants.dart';
import 'package:flutter/cupertino.dart';

class TimerWidget extends StatelessWidget {
  final Duration timeLeft;
  final Color color;

  TimerWidget({@required this.timeLeft, @required this.color});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        height: ViewConstants.BUTTON_HEIGHT,
        child: Center(
          child: TextRegular(_durationToString(timeLeft)),
        ),
        decoration: BoxDecoration(
          border: Border.all(
            color: color,
            width: ViewConstants.BORDER_WIDTH_SMALL,
          ),
          borderRadius: BorderRadius.circular(
            ViewConstants.BORDER_RADIUS,
          ),
          color: ViewConstants.BACKGROUND_COLOR,
        ),
      ),
    );
  }

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
}
