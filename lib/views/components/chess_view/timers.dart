import 'package:en_passant/views/components/chess_view/timer_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Timers extends StatelessWidget {
  final Duration player1TimeLeft;
  final Duration player2TimeLeft;

  Timers({@required this.player1TimeLeft, @required this.player2TimeLeft});

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Row(
        children: [
          TimerWidget(timeLeft: player1TimeLeft, color: Colors.white),
          SizedBox(width: 10),
          TimerWidget(timeLeft: player2TimeLeft, color: Colors.black),
        ],
      ),
    );
  }
}
