import 'package:flutter/material.dart';

import '../constants/view_constants.dart';
import '../model/app_model.dart';
import 'gap.dart';

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
                    GapRowSmall(),
                    TimerWidget(
                      timeLeft: appModel.gameData.player2TimeLeft,
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
