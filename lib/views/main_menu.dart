import 'package:en_passant/settings/game_settings.dart';
import 'package:en_passant/views/chess_widget.dart';
import 'package:en_passant/views/components/piece_color_picker.dart';
import 'package:en_passant/views/components/rounded_button.dart';
import 'package:en_passant/views/components/player_count_picker.dart';
import 'package:en_passant/views/components/ai_difficulty_picker.dart';
import 'package:en_passant/views/components/time_limit_picker.dart';
import 'package:en_passant/views/settings.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';

class MainMenu extends StatefulWidget {
  @override
  _MainMenuState createState() => _MainMenuState();
}

class _MainMenuState extends State<MainMenu> {
  @override
  Widget build(BuildContext context) {
    return Consumer<GameSettings>(
      builder: (context, gameSettings, child) => Container(
        decoration: BoxDecoration(
          gradient: gameSettings.theme.background
        ),
        padding: EdgeInsets.fromLTRB(30, 80, 30, 0),
        child: Column(
          children: [
            Image(image: AssetImage('assets/images/logo.png')),
            SizedBox(height: 30),
            PlayerCountPicker(gameSettings.playerCount, gameSettings.setPlayerCount),
            SizedBox(height: 30),
              gameSettings.playerCount == 1
                ? Column(children: [
                    AIDifficultyPicker(gameSettings.aiDifficulty, gameSettings.setAIDifficulty),
                    SizedBox(height: 30),
                    PieceColorPicker(gameSettings.playerSide, gameSettings.setPlayerSize)
                  ])
                : TimeLimitPicker(setTime: gameSettings.setTimeLimit),
            Spacer(),
            RoundedButton(
              label: "Start",
              onPressed: () {
                Navigator.push(context,
                  CupertinoPageRoute(builder: (context) => ChessWidget())
                );
              },
            ),
            SizedBox(height: 10),
            Row(children: [
              Expanded(
                child: RoundedButton(label: "Load Game", onPressed: () {}),
              ),
              SizedBox(width: 10),
              Expanded(
                child: RoundedButton(label: "Settings", onPressed: () {
                  Navigator.push(context,
                    CupertinoPageRoute(builder: (context) => Settings())
                  );
                }),
              )
            ]),
            SizedBox(height: 30)
          ],
        ),
      )
    );
  }
}
