import 'dart:async';

import 'package:en_passant/logic/chess_game.dart';
import 'package:en_passant/model/game_settings.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';

import 'components/chess_view/game_status.dart';
import 'components/chess_view/move_list.dart';
import 'components/chess_view/timers.dart';
import 'components/main_menu_view/side_picker.dart';
import 'components/shared/bottom_padding.dart';
import 'components/shared/rounded_button.dart';

class ChessView extends StatefulWidget {
  @override
  _ChessViewState createState() => _ChessViewState();
}

class _ChessViewState extends State<ChessView> {
  var game = ChessGame();
  GameSettings gameSettings;
  Timer timer;

  _ChessViewState() {
    timer = Timer.periodic(
      Duration(seconds: 1), 
      (timer) {
        if (gameSettings != null && gameSettings.timeLimit != Duration.zero) {
          gameSettings.turn == PlayerID.player1 ?
            gameSettings.decrementPlayer1Timer() :
            gameSettings.decrementPlayer2Timer();
          if (gameSettings.player1TimeLeft == Duration.zero ||
            gameSettings.player2TimeLeft == Duration.zero) {
            gameSettings.endGame();
          }
        }
      }
    );
  }

  @override
  Widget build(BuildContext context) {  
    return Consumer<GameSettings>(
      builder: (context, gameSettings, child) {
        initGame(context, gameSettings);
        return WillPopScope(
          child: Container(
            decoration: BoxDecoration(gradient: gameSettings.theme.background),
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
                gameSettings.playerCount == 2 && 
                  gameSettings.timeLimit != Duration.zero ?
                  Column(children: [
                    Timers(
                      player1TimeLeft: gameSettings.player1TimeLeft,
                      player2TimeLeft: gameSettings.player2TimeLeft,
                    ),
                    SizedBox(height: 14)
                  ]) : Container(),
                gameSettings.showMoveHistory ?
                  Column(children: [
                    MoveList(),
                    SizedBox(height: 10)
                  ]) : Container(),
                RoundedButton(
                  label: 'Exit',
                  onPressed: () {
                    gameSettings.resetGame();
                    timer.cancel();
                    Navigator.pop(context);
                  }
                ),
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
    gameSettings.resetGame();
    timer.cancel();
    return true;
  }

  void initGame(BuildContext context, GameSettings gameSettings) {
    this.gameSettings = gameSettings;
    if (gameSettings.initGame) {
      game.setSize(MediaQuery.of(context).size);
      game.setGameSettings(gameSettings);
      game.initSpritePositions();
      if (gameSettings.isAIsTurn) {
        game.aiMove();
      }
      gameSettings.initGame = false;
    }
  }
}
