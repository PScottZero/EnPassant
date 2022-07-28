import 'package:flutter/cupertino.dart';

import '../constants/view_constants.dart';
import '../model/app_model.dart';
import 'moves_undo_redo_row.dart';
import 'restart_exit_buttons.dart';
import 'timers.dart';

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

  double _maxHeight(BuildContext context) {
    return MediaQuery.of(context).size.height >
            ViewConstants.SMALL_SCREEN_CUTOFF
        ? ViewConstants.gameInfoMaxHeight
        : ViewConstants.gameInfoMinHeight;
  }

  void _scrollToBottom() {
    scrollController.jumpTo(scrollController.position.maxScrollExtent);
  }
}
