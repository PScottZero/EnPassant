import 'package:en_passant/model/app_model.dart';
import 'package:en_passant/views/components/gap.dart';
import 'package:flutter/cupertino.dart';

import 'rounded_icon_button.dart';

class UndoRedoButtons extends StatelessWidget {
  final AppModel appModel;

  bool get undoEnabled {
    if (appModel.gameData.playingWithAI) {
      return appModel.gameData.game.board.moveStack.length > 1 &&
          !appModel.gameData.isAIsTurn;
    } else {
      return appModel.gameData.game.board.moveStack.isNotEmpty;
    }
  }

  bool get redoEnabled {
    if (appModel.gameData.playingWithAI) {
      return appModel.gameData.game.board.redoStack.length > 1 &&
          !appModel.gameData.isAIsTurn;
    } else {
      return appModel.gameData.game.board.redoStack.isNotEmpty;
    }
  }

  UndoRedoButtons(this.appModel);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: RoundedIconButton(
            CupertinoIcons.arrow_counterclockwise,
            onPressed: undoEnabled ? () => undo() : null,
          ),
        ),
        GapRowSmall(),
        Expanded(
          child: RoundedIconButton(
            CupertinoIcons.arrow_clockwise,
            onPressed: redoEnabled ? () => redo() : null,
          ),
        ),
      ],
    );
  }

  void undo() {
    if (appModel.gameData.playingWithAI) {
      appModel.gameData.game.undoTwoMoves();
    } else {
      appModel.gameData.game.undoMove();
    }
  }

  void redo() {
    if (appModel.gameData.playingWithAI) {
      appModel.gameData.game.redoTwoMoves();
    } else {
      appModel.gameData.game.redoMove();
    }
  }
}
