import 'package:flutter/cupertino.dart';

import '../model/app_model.dart';
import 'ai_difficulty_segmented_control.dart';
import 'game_mode_segmented_control.dart';
import 'gap.dart';
import 'side_segmented_control.dart';
import 'time_limit_segmented_control.dart';

class GameOptions extends StatelessWidget {
  final AppModel appModel;

  GameOptions(this.appModel);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: ListView(
        padding: EdgeInsets.zero,
        physics: ClampingScrollPhysics(),
        children: [
          GameModePicker(
            appModel.gameData.playerCount,
            appModel.gameData.setPlayerCount,
          ),
          GapColumnSmall(),
          appModel.gameData.playerCount == 1
              ? Column(
                  children: [
                    AIDifficultyPicker(
                      appModel.gameData.aiDifficulty,
                      appModel.gameData.setAIDifficulty,
                    ),
                    GapColumnSmall(),
                    SidePicker(
                      appModel.gameData.selectedSide,
                      appModel.gameData.setPlayerSide,
                    ),
                    GapColumnSmall(),
                  ],
                )
              : Container(),
          TimeLimitPicker(
            selectedTime: appModel.gameData.timeLimit,
            setTime: appModel.gameData.setTimeLimit,
          ),
        ],
      ),
    );
  }
}
