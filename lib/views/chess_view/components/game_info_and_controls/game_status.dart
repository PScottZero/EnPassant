import 'package:en_passant/model/app_model.dart';
import 'package:en_passant/views/components/text_variable.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class GameStatus extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<AppModel>(
      builder: (context, appModel, child) => Row(
        children: [
          TextRegular(_getStatus(appModel)),
          !appModel.gameData.gameOver && appModel.gameData.playerCount == 1 && appModel.gameData.isAIsTurn
              ? CupertinoActivityIndicator(radius: 12)
              : Container()
        ],
        mainAxisAlignment: MainAxisAlignment.center,
      ),
    );
  }

  String _getStatus(AppModel appModel) {
    if (!appModel.gameData.gameOver) {
      if (appModel.gameData.playerCount == 1) {
        if (appModel.gameData.isAIsTurn) {
          return 'AI [Level ${appModel.gameData.aiDifficulty}] is thinking ';
        } else {
          return 'Your turn';
        }
      } else {
        if (appModel.gameData.turn == Player.player1) {
          return 'White\'s turn';
        } else {
          return 'Black\'s turn';
        }
      }
    } else {
      if (appModel.gameData.stalemate) {
        return 'Stalemate';
      } else {
        if (appModel.gameData.playerCount == 1) {
          if (appModel.gameData.isAIsTurn) {
            return 'You Win!';
          } else {
            return 'You Lose :(';
          }
        } else {
          if (appModel.gameData.turn == Player.player1) {
            return 'Black wins!';
          } else {
            return 'White wins!';
          }
        }
      }
    }
  }
}
