import 'dart:async';
import 'dart:math';

import 'package:en_passant/logic/chess_game.dart';
import 'package:en_passant/model/app_model.dart';
import 'package:en_passant/views/components/chess_view/loading_animation.dart';
import 'package:en_passant/views/components/chess_view/rounded_alert_button.dart';
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

  _ChessViewState(this.game) {
    timer = Timer.periodic(
      Duration(milliseconds: 50), 
      (timer) {
        game.appModel.turn == Player.player1 ?
          game.appModel.decrementPlayer1Timer() :
          game.appModel.decrementPlayer2Timer();
        if ((game.appModel.player1TimeLeft == Duration.zero ||
          game.appModel.player2TimeLeft == Duration.zero) &&
          game.appModel.timeLimit != Duration.zero) {
          game.appModel.endGame();
        }
      }
    );
  }

  @override
  Widget build(BuildContext context) {  
    return Consumer<AppModel>(
      builder: (context, appModel, child) {
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
                Row(
                  children: [
                    GameStatus(),
                    LoadingAnimation(appModel)
                  ],
                  mainAxisAlignment: MainAxisAlignment.center,
                ),
                Spacer(),
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
                      game.cancelAIMove();
                      game = ChessGame(appModel, context);
                    })
                  ),
                  SizedBox(width: 10),
                  Expanded(
                    child: RoundedAlertButton('Exit', onConfirm: () {
                      game.cancelAIMove();
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
    game.cancelAIMove();
    timer.cancel();
    return true;
  }
}
