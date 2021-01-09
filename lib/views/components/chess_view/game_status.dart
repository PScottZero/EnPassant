import 'package:en_passant/model/app_model.dart';
import 'package:en_passant/views/components/main_menu_view/ai_difficulty_picker.dart';
import 'package:en_passant/views/components/main_menu_view/side_picker.dart';
import 'package:en_passant/views/components/shared/text_variable.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class GameStatus extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<AppModel>(
      builder: (context, appModel, child) => 
        TextRegular(getStatus(appModel))
    );
  }

  String getStatus(AppModel appModel) {
    if (!appModel.gameOver) {
      if (appModel.playerCount == 1) {
        if (appModel.isAIsTurn) {
          return 'AI [${getAIDifficulty(appModel)}] is thinking...';
        } else {
          return 'Your turn';
        }
      } else {
        if (appModel.turn == Player.player1) {
          return 'White\'s turn';
        } else {
          return 'Black\'s turn';
        }
      }
    } else {
      if (appModel.playerCount == 1) {
        if (appModel.isAIsTurn) {
          return 'You Win!';
        } else {
          return 'You Lose :(';
        }
      } else {
        if (appModel.turn == Player.player1) {
          return 'Black wins!';
        } else {
          return 'White wins!';
        }
      }
    }
  }

  String getAIDifficulty(AppModel appModel) {
    switch (appModel.aiDifficulty) {
      case AIDifficulty.easy: { return 'Easy'; }
      case AIDifficulty.normal: { return 'Normal'; }
      case AIDifficulty.hard: { return 'Hard'; }
      default: { return ''; }
    }
  }
}
