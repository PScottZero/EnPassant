import 'package:en_passant/model/app_model.dart';
import 'package:en_passant/views/components/main_menu_view/side_picker.dart';
import 'package:en_passant/views/components/main_menu_view/game_mode_picker.dart';
import 'package:en_passant/views/components/main_menu_view/ai_difficulty_picker.dart';
import 'package:en_passant/views/components/main_menu_view/time_limit_picker.dart';
import 'package:en_passant/views/components/shared/bottom_padding.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';

import 'components/main_menu_view/main_menu_buttons.dart';

class MainMenuView extends StatefulWidget {
  @override
  _MainMenuViewState createState() => _MainMenuViewState();
}

class _MainMenuViewState extends State<MainMenuView> {
  @override
  Widget build(BuildContext context) {
    return Consumer<AppModel>(
      builder: (context, appModel, child) => Container(
        decoration: BoxDecoration(
          gradient: appModel.theme.background
        ),
        padding: EdgeInsets.all(30),
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.fromLTRB(
                10, MediaQuery.of(context).padding.top + 10, 10, 0
              ),
              child: Image(image: AssetImage('assets/images/logo.png')),
            ),
            SizedBox(height: 20),
            GameModePicker(
              appModel.playerCount,
              appModel.setPlayerCount
            ),
            SizedBox(height: 20),
            appModel.playerCount == 1
              ? Column(children: [
                  AIDifficultyPicker(
                    appModel.aiDifficulty,
                    appModel.setAIDifficulty
                  ),
                  SizedBox(height: 20),
                  SidePicker(
                    appModel.selectedSide,
                    appModel.setPlayerSide
                  ),
                  SizedBox(height: 20)
                ])
              : Container(),
            TimeLimitPicker(
              selectedTime: appModel.timeLimit,
              setTime: appModel.setTimeLimit,
            ),
            Spacer(),
            MainMenuButtons(appModel),
            BottomPadding()
          ],
        ),
      )
    );
  }
}
