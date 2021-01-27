import 'package:en_passant/logic/chess_game.dart';
import 'package:en_passant/model/app_model.dart';
import 'package:en_passant/views/components/chess_view/rounded_icon_button.dart';
import 'package:flutter/cupertino.dart';

class UndoRedoButtons extends StatelessWidget {
  final AppModel appModel;
  final ChessGame game;

  bool get undoEnabled {
    if (appModel.playingWithAI) {
      return game.board.moveStack.length > 1 && !appModel.isAIsTurn;
    } else {
      return game.board.moveStack.isNotEmpty;
    }
  }

  bool get redoEnabled {
    if (appModel.playingWithAI) {
      return game.board.redoStack.length > 1 && !appModel.isAIsTurn;
    } else {
      return game.board.redoStack.isNotEmpty;
    }
  }

  UndoRedoButtons(this.appModel, this.game);

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
        SizedBox(width: 10),
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
    if (appModel.playingWithAI) {
      game.undoTwoMoves();
    } else {
      game.undoMove();
    }
  }

  void redo() {
    if (appModel.playingWithAI) {
      game.redoTwoMoves();
    } else {
      game.redoMove();
    }
  }
}
