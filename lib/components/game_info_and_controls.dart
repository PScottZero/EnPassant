import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../constants/view_constants.dart';
import '../model/app_model.dart';
import 'gap.dart';
import 'moves_undo_redo_row.dart';
import 'rounded_alert_button.dart';
import 'timer_widget.dart';

class GameInfoAndControls extends StatelessWidget {
  final AppModel appModel;
  final ScrollController scrollController = ScrollController();

  GameInfoAndControls(this.appModel);

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) => _scrollToBottom());
    return Consumer<AppModel>(
      builder: (context, model, child) => Container(
        constraints: BoxConstraints(
          maxHeight: _maxHeight(context),
        ),
        child: ListView(
          controller: scrollController,
          physics: ClampingScrollPhysics(),
          shrinkWrap: true,
          padding: EdgeInsets.zero,
          children: [
            model.gameData.timeLimit != 0
                ? Column(
                    children: [
                      Container(
                        child: Row(
                          children: [
                            TimerWidget(
                              timeLeft: model.gameData.player1TimeLeft,
                              color: Colors.white,
                            ),
                            GapRowSmall(),
                            TimerWidget(
                              timeLeft: model.gameData.player2TimeLeft,
                              color: Colors.black,
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: ViewConstants.smallGap +
                            ViewConstants.largeBorderWidth,
                      ),
                    ],
                  )
                : Container(),
            MovesUndoRedoRow(appModel),
            Row(
              children: [
                Expanded(
                  child: RoundedAlertButton(
                    'Restart',
                    onConfirm: () {
                      appModel.gameData.newGame();
                    },
                  ),
                ),
                GapRowSmall(),
                Expanded(
                  child: RoundedAlertButton(
                    'Exit',
                    onConfirm: () {
                      appModel.exitChessView();
                      Navigator.pop(context);
                    },
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  double _maxHeight(BuildContext context) {
    return MediaQuery.of(context).size.height > ViewConstants.smallScreenCutoff
        ? ViewConstants.gameInfoMaxHeight
        : ViewConstants.gameInfoMinHeight;
  }

  void _scrollToBottom() {
    scrollController.jumpTo(scrollController.position.maxScrollExtent);
  }
}
