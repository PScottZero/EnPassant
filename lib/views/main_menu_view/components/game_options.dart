import 'package:en_passant/model/app_model.dart';
import 'package:en_passant/views/components/gap.dart';
import 'package:en_passant/views/constants/view_constants.dart';
import 'package:flutter/cupertino.dart';

import 'game_options/ai_difficulty_segmented_control.dart';
import 'game_options/game_mode_segmented_control.dart';
import 'game_options/side_segmented_control.dart';
import 'game_options/time_limit_segmented_control.dart';

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
