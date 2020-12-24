import 'package:en_passant/logic/chess_game.dart';
import 'package:en_passant/settings/game_settings.dart';
import 'package:en_passant/views/components/chess_view/save_exit_buttons.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';

import 'components/chess_view/game_status.dart';
import 'components/chess_view/move_list.dart';
import 'components/shared/bottom_padding.dart';

class ChessView extends StatefulWidget {
  @override
  _ChessViewState createState() => _ChessViewState();
}

class _ChessViewState extends State<ChessView> {
  var game = ChessGame();

  @override
  Widget build(BuildContext context) {  
    return Consumer<GameSettings>(
      builder: (context, gameSettings, child) {
        initGame(context, gameSettings);
        return Container(
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
              gameSettings.showMoveHistory ?
                Column(children: [
                  MoveList(),
                  SizedBox(height: 10)
                ]) : Container(),
              SaveExitButtons(),
              BottomPadding()
            ],
          )
        );
      }
    );
  }

  void initGame(BuildContext context, GameSettings gameSettings) {
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
