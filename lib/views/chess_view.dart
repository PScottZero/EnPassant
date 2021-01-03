import 'dart:async';

import 'package:en_passant/logic/chess_game.dart';
import 'package:en_passant/model/app_model.dart';
import 'package:en_passant/views/components/chess_view/rounded_alert_button.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';

import 'components/chess_view/game_status.dart';
import 'components/chess_view/move_list.dart';
import 'components/chess_view/timers.dart';
import 'components/main_menu_view/side_picker.dart';
import 'components/shared/bottom_padding.dart';

class ChessView extends StatefulWidget {
  @override
  _ChessViewState createState() => _ChessViewState();
}

class _ChessViewState extends State<ChessView> {
  var game = ChessGame();
  AppModel appModel;
  Timer timer;

  _ChessViewState() {
    timer = Timer.periodic(
      Duration(seconds: 1), 
      (timer) {
        if (appModel != null && appModel.timeLimit != Duration.zero) {
          appModel.turn == PlayerID.player1 ?
            appModel.decrementPlayer1Timer() :
            appModel.decrementPlayer2Timer();
          if (appModel.player1TimeLeft == Duration.zero ||
            appModel.player2TimeLeft == Duration.zero) {
            appModel.endGame();
          }
        }
      }
    );
  }

  @override
  Widget build(BuildContext context) {  
    return Consumer<AppModel>(
      builder: (context, appModel, child) {
        initGame(context, appModel);
        return WillPopScope(
          child: Container(
            decoration: BoxDecoration(gradient: appModel.theme.background),
            padding: EdgeInsets.all(30),
            child: Column(
              children: [
                Spacer(),
                Container(
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: CupertinoColors.white,
                      width: 4
                    ),
                    borderRadius: BorderRadius.circular(14),
                    boxShadow: [
                      BoxShadow(
                        blurRadius: 10,
                        color: Color(0x88000000)
                      )
                    ]
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: Container(
                      child: game.widget,
                      width: MediaQuery.of(context).size.width - 68,
                      height: MediaQuery.of(context).size.width - 68
                    )
                  ),
                ),
                SizedBox(height: 30),
                GameStatus(),
                Spacer(),
                appModel.playerCount == 2 && 
                  appModel.timeLimit != Duration.zero ?
                  Column(children: [
                    Timers(
                      player1TimeLeft: appModel.player1TimeLeft,
                      player2TimeLeft: appModel.player2TimeLeft,
                    ),
                    SizedBox(height: 14)
                  ]) : Container(),
                appModel.showMoveHistory ?
                  Column(children: [
                    MoveList(),
                    SizedBox(height: 10)
                  ]) : Container(),
                Row(children: [
                  Expanded(
                    child: RoundedAlertButton('Restart', onConfirm: () {
                      appModel.resetGame();
                      game = ChessGame();
                      initGame(context, appModel);
                    })
                  ),
                  SizedBox(width: 10),
                  Expanded(
                    child: RoundedAlertButton('Exit', onConfirm: () {
                      appModel.resetGame();
                      timer.cancel();
                      Navigator.pop(context);
                    })
                  )
                ]),
                BottomPadding()
              ],
            )
          ),
          onWillPop: _willPopCallback
        );
      }
    );
  }

  Future<bool> _willPopCallback() async {
    appModel.resetGame();
    timer.cancel();
    return true;
  }

  void initGame(BuildContext context, AppModel appModel) {
    this.appModel = appModel;
    if (appModel.initGame) {
      game.setSize(MediaQuery.of(context).size);
      game.setappModel(appModel);
      game.initSpritePositions();
      if (appModel.isAIsTurn) {
        game.aiMove();
      }
      WidgetsBinding.instance.addPostFrameCallback((_) {
        appModel.finalizeGameInit();
      });
    }
  }
}
