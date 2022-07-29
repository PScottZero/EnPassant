import 'package:flutter/material.dart';

import '../constants/view_constants.dart';
import 'gap.dart';
import 'timer_widget.dart';

class Timers extends StatelessWidget {
  final int timeLimit;
  final Duration player1TimeLeft;
  final Duration player2TimeLeft;

  const Timers({
    Key? key,
    required this.timeLimit,
    required this.player1TimeLeft,
    required this.player2TimeLeft,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return timeLimit != 0
        ? Column(
            children: [
              Container(
                child: Row(
                  children: [
                    TimerWidget(
                      timeLeft: player1TimeLeft,
                      color: Colors.white,
                    ),
                    GapRowSmall(),
                    TimerWidget(
                      timeLeft: player2TimeLeft,
                      color: Colors.black,
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: ViewConstants.smallGap + ViewConstants.largeBorderWidth,
              ),
            ],
          )
        : Container();
  }
}
