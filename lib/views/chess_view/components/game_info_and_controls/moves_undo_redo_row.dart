import 'package:en_passant/model/app_model.dart';
import 'package:flutter/cupertino.dart';

import 'moves_undo_redo_row/move_list.dart';
import 'moves_undo_redo_row/undo_redo_buttons.dart';

class MovesUndoRedoRow extends StatelessWidget {
  final AppModel appModel;

  MovesUndoRedoRow(this.appModel);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            appModel.showMoveHistory
                ? Expanded(child: MoveList(appModel))
                : Container(),
            appModel.showMoveHistory && appModel.allowUndoRedo
                ? SizedBox(width: 10)
                : Container(),
            appModel.allowUndoRedo
                ? Expanded(child: UndoRedoButtons(appModel))
                : Container(),
          ],
        ),
        appModel.showMoveHistory || appModel.allowUndoRedo
            ? SizedBox(height: 10)
            : Container(),
      ],
    );
  }
}