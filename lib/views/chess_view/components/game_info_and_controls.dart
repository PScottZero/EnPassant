import 'package:en_passant/model/app_model.dart';
import 'package:en_passant/views/view_constants.dart';
import 'package:flutter/cupertino.dart';

import 'game_info_and_controls/moves_undo_redo_row.dart';
import 'game_info_and_controls/restart_exit_buttons.dart';
import 'game_info_and_controls/timers.dart';

class GameInfoAndControls extends StatelessWidget {
  final AppModel appModel;
  final ScrollController scrollController = ScrollController();

  GameInfoAndControls(this.appModel);

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) => _scrollToBottom());
    return Container(
      constraints: BoxConstraints(
        maxHeight: _maxHeight(context),
      ),
      child: ListView(
        controller: scrollController,
        physics: ClampingScrollPhysics(),
        shrinkWrap: true,
        padding: EdgeInsets.zero,
        children: [
          Timers(appModel),
          MovesUndoRedoRow(appModel),
          RestartExitButtons(appModel),
        ],
      ),
    );
  }

  double _maxHeight(BuildContext context) =>
      MediaQuery.of(context).size.height > ViewConstants.SMALL_SCREEN_CUTOFF
          ? ViewConstants.GAME_INFO_MAX_HEIGHT
          : ViewConstants.GAME_INFO_MIN_HEIGHT;

  void _scrollToBottom() =>
      scrollController.jumpTo(scrollController.position.maxScrollExtent);
}
