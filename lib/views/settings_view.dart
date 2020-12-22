import 'package:en_passant/settings/game_settings.dart';
import 'package:en_passant/views/components/shared/rounded_button.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';

import 'components/settings/theme_picker.dart';
import 'components/shared/bottom_padding.dart';

class SettingsView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<GameSettings>(
      builder: (context, gameSettings, child) => Container(
        decoration: BoxDecoration(gradient: gameSettings.theme.background),
        padding: EdgeInsets.all(30),
        child: Column(
          children: [
            SizedBox(height: MediaQuery.of(context).padding.top),
            Text(
              "Settings",
              style: TextStyle(fontSize: 36)
            ),
            SizedBox(height: 30),
            ThemePicker(),
            Spacer(),
            RoundedButton(
              label: "Back",
              onPressed: () {
                Navigator.pop(context);
              },
            ),
            BottomPadding()
          ],
        )
      )
    );
  }
}