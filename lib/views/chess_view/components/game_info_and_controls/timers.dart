import 'package:en_passant/model/app_model.dart';
import 'package:en_passant/views/components/gap.dart';
import 'package:en_passant/views/view_constants.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'timers/timer_widget.dart';

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
                height:
                    ViewConstants.GAP_SMALL + ViewConstants.BORDER_WIDTH_LARGE,
              ),
            ],
          )
        : Container();
  }
}
