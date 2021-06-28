import 'package:en_passant/model/app_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'timer_widget.dart';

class Timers extends StatelessWidget {
  final AppModel appModel;

  Timers(this.appModel);

  @override
  Widget build(BuildContext context) {
    return appModel.gameData.timeLimit != 0
        ? Column(
            children: [
              Container(
                child: Row(
                  children: [
                    TimerWidget(
                      timeLeft: appModel.gameData.player1TimeLeft,
                      color: Colors.white,
                    ),
                    SizedBox(width: 10),
                    TimerWidget(
                      timeLeft: appModel.gameData.player2TimeLeft,
                      color: Colors.black,
                    ),
                  ],
                ),
              ),
              SizedBox(height: 14),
            ],
          )
        : Container();
  }
}
