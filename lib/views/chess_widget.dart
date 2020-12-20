import 'package:en_passant/settings/game_settings.dart';
import 'package:en_passant/views/components/rounded_button.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';

class ChessWidget extends StatefulWidget {
  @override
  _ChessWidgetState createState() => _ChessWidgetState();
}

class _ChessWidgetState extends State<ChessWidget> {
  @override
  Widget build(BuildContext context) {
    return Consumer<GameSettings>(
      builder: (context, gameSettings, child) => Container(
        decoration: BoxDecoration(
          gradient: gameSettings.theme.background
        ),
        padding: EdgeInsets.all(30),
        child: Column(
          children: [
            Spacer(),
            RoundedButton(
              label: "Exit",
              onPressed: () {
                Navigator.pop(context);
              }
            )
          ],
        )
      ),
    );
  }
}
