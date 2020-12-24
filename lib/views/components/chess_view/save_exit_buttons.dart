import 'package:en_passant/settings/game_settings.dart';
import 'package:en_passant/views/components/shared/rounded_button.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';

class SaveExitButtons extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<GameSettings>(
      builder: (context, gameSettings, child) => Row(
        children: [
          Expanded(
            child: RoundedButton(
              label: "Save Game",
              onPressed: () {}
            ),
          ),
          SizedBox(width: 10),
          Expanded(
            child: RoundedButton(
              label: "Exit",
              onPressed: () {
                gameSettings.resetGame();
                Navigator.pop(context);
              }
            ),
          )
        ],
      )
    );
  }
}