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
            appModel.playerCount,
            appModel.setPlayerCount,
          ),
          SizedBox(height: 20),
          appModel.playerCount == 1
              ? Column(
                  children: [
                    AIDifficultyPicker(
                      appModel.aiDifficulty,
                      appModel.setAIDifficulty,
                    ),
                    SizedBox(height: 20),
                    SidePicker(
                      appModel.selectedSide,
                      appModel.setPlayerSide,
                    ),
                    SizedBox(height: 20),
                  ],
                )
              : Container(),
          TimeLimitPicker(
            selectedTime: appModel.timeLimit,
            setTime: appModel.setTimeLimit,
          ),
        ],
      ),
    );
  }
}
