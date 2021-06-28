import 'package:en_passant/model/app_model.dart';
import 'package:flutter/cupertino.dart';

import 'game_options/ai_difficulty_picker.dart';
import 'game_options/game_mode_picker.dart';
import 'game_options/side_picker.dart';
import 'game_options/time_limit_picker.dart';

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
          SizedBox(height: 20),
          appModel.gameData.playerCount == 1
              ? Column(
                  children: [
                    AIDifficultyPicker(
                      appModel.gameData.aiDifficulty,
                      appModel.gameData.setAIDifficulty,
                    ),
                    SizedBox(height: 20),
                    SidePicker(
                      appModel.gameData.selectedSide,
                      appModel.gameData.setPlayerSide,
                    ),
                    SizedBox(height: 20),
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
