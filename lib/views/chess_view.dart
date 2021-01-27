import 'dart:async';

import 'package:en_passant/logic/chess_game.dart';
import 'package:en_passant/model/app_model.dart';
import 'package:en_passant/views/components/chess_view/loading_animation.dart';
import 'package:en_passant/views/components/chess_view/promotion_dialog.dart';
import 'package:en_passant/views/components/chess_view/rounded_alert_button.dart';
import 'package:en_passant/views/components/chess_view/undo_redo_buttons.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';

import 'components/chess_view/game_status.dart';
import 'components/chess_view/move_list.dart';
import 'components/chess_view/timers.dart';
import 'components/main_menu_view/side_picker.dart';
import 'components/shared/bottom_padding.dart';

class ChessView extends StatefulWidget {
  final ChessGame game;

  ChessView(this.game);

  @override
  _ChessViewState createState() => _ChessViewState(game);
}

class _ChessViewState extends State<ChessView> {
  ChessGame game;
  Timer timer;
  final ScrollController scrollController = ScrollController();

  _ChessViewState(this.game) {
    timer = Timer.periodic(Duration(milliseconds: TIMER_ACCURACY_MS), (timer) {
      game.appModel.turn == Player.player1
          ? game.appModel.decrementPlayer1Timer()
          : game.appModel.decrementPlayer2Timer();
      if ((game.appModel.player1TimeLeft == Duration.zero ||
              game.appModel.player2TimeLeft == Duration.zero) &&
          game.appModel.timeLimit != Duration.zero) {
        game.appModel.endGame();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) => scrollToBottom());
    return Consumer<AppModel>(
      builder: (context, appModel, child) {
        if (appModel.promotion) {
          WidgetsBinding.instance
              .addPostFrameCallback((_) => showPromotionDialog(appModel));
        }
        return WillPopScope(
          child: Container(
            decoration: BoxDecoration(gradient: appModel.theme.background),
            padding: EdgeInsets.all(30),
            child: Column(
              children: [
                Spacer(),
                Container(
                  decoration: appModel.theme.name != 'Video Chess'
                      ? BoxDecoration(
                          border: Border.all(
                            color: appModel.theme.border,
                            width: 4,
                          ),
                          borderRadius: BorderRadius.circular(14),
                          boxShadow: [
                            BoxShadow(
                              blurRadius: 10,
                              color: Color(0x88000000),
                            ),
                          ],
                        )
                      : BoxDecoration(),
                  child: ClipRRect(
                    borderRadius: appModel.theme.name != 'Video Chess'
                        ? BorderRadius.circular(10)
                        : BorderRadius.zero,
                    child: Container(
                      child: game.widget,
                      width: MediaQuery.of(context).size.width - 68,
                      height: MediaQuery.of(context).size.width - 68,
                    ),
                  ),
                ),
                SizedBox(height: 30),
                Row(
                  children: [GameStatus(), LoadingAnimation(appModel)],
                  mainAxisAlignment: MainAxisAlignment.center,
                ),
                Spacer(),
                Container(
                  constraints: BoxConstraints(
                    maxHeight:
                        MediaQuery.of(context).size.height > 700 ? 204 : 134,
                  ),
                  child: ListView(
                    controller: scrollController,
                    physics: ClampingScrollPhysics(),
                    shrinkWrap: true,
                    padding: EdgeInsets.zero,
                    children: [
                      appModel.timeLimit != Duration.zero
                          ? Column(
                              children: [
                                Timers(
                                  player1TimeLeft: appModel.player1TimeLeft,
                                  player2TimeLeft: appModel.player2TimeLeft,
                                ),
                                SizedBox(height: 14),
                              ],
                            )
                          : Container(),
                      Row(
                        children: [
                          appModel.showMoveHistory
                              ? Expanded(child: MoveList())
                              : Container(),
                          appModel.showMoveHistory && appModel.allowUndoRedo
                              ? SizedBox(width: 10)
                              : Container(),
                          appModel.allowUndoRedo
                              ? Expanded(child: UndoRedoButtons(appModel, game))
                              : Container()
                        ],
                      ),
                      appModel.showMoveHistory || appModel.allowUndoRedo
                          ? SizedBox(height: 10)
                          : Container(),
                      Row(
                        children: [
                          Expanded(
                            child: RoundedAlertButton(
                              'Restart',
                              onConfirm: () {
                                game.cancelAIMove();
                                game = ChessGame(appModel, context);
                                game.appModel.update();
                              },
                            ),
                          ),
                          SizedBox(width: 10),
                          Expanded(
                            child: RoundedAlertButton(
                              'Exit',
                              onConfirm: () {
                                exit();
                                Navigator.pop(context);
                              },
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                BottomPadding(),
              ],
            ),
          ),
          onWillPop: _willPopCallback,
        );
      },
    );
  }

  void showPromotionDialog(AppModel appModel) {
    showCupertinoDialog(
      context: context,
      builder: (BuildContext context) {
        return PromotionDialog(appModel, game);
      },
    );
  }

  void scrollToBottom() {
    scrollController.jumpTo(scrollController.position.maxScrollExtent);
  }

  Future<bool> _willPopCallback() async {
    exit();
    return true;
  }

  void exit() {
    game.cancelAIMove();
    timer.cancel();
  }
}
