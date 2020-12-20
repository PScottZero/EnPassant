import 'package:en_passant/settings/game_settings.dart';
import 'package:en_passant/settings/game_themes.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';

class ThemePicker extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<GameSettings>(
      builder: (context, gameSettings, child) => Container(
        child: Stack(
          alignment: AlignmentDirectional.topStart,
          children: [
            Container(
              child: Text(
                "App Theme",
                style: TextStyle(fontSize: 24),
              ),
              padding: EdgeInsets.all(10),
            ),
            CupertinoPicker(
              scrollController: FixedExtentScrollController(
                initialItem: gameSettings.themeIndex
              ),
              itemExtent: 30,
              onSelectedItemChanged: gameSettings.setGameTheme,
              children: GameThemes.themeList.map((theme) => 
                Text(theme.name, style: TextStyle(fontSize: 24))).toList()
            ),
          ],
        ),
        height: 200,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(20)),
          gradient: gameSettings.theme.background
        ),
      ),
    );
  }
}