import 'package:en_passant/model/app_model.dart';
import 'package:en_passant/views/components/bottom_padding.dart';
import 'package:en_passant/views/components/gap.dart';
import 'package:en_passant/views/components/rounded_button.dart';
import 'package:en_passant/views/components/text_variable.dart';
import 'package:en_passant/views/view_constants.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';

import 'components/app_theme_picker.dart';
import 'components/piece_theme_picker.dart';
import 'components/toggles.dart';

class SettingsView extends StatefulWidget {
  @override
  _SettingsViewState createState() => _SettingsViewState();
}

class _SettingsViewState extends State<SettingsView> {
  AppModel model;
  bool init = true;

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _willPopCallback,
      child: Consumer<AppModel>(
        builder: (context, appModel, child) {
          if (init) {
            appModel.gameData.pauseTimers();
            model = appModel;
            init = false;
          }
          return Container(
            decoration: BoxDecoration(
              gradient: appModel.themePrefs.theme.background,
            ),
            padding: EdgeInsets.all(ViewConstants.PADDING_LARGE),
            child: Column(
              children: [
                SizedBox(height: MediaQuery.of(context).padding.top),
                TextLarge('Settings'),
                GapColumnSmall(),
                Expanded(
                  child: ListView(
                    padding: EdgeInsets.zero,
                    physics: ClampingScrollPhysics(),
                    children: [
                      AppThemePicker(),
                      GapColumnSmall(),
                      PieceThemePicker(),
                      GapColumnSmall(),
                      Toggles(appModel),
                    ],
                  ),
                ),
                GapColumnSmall(),
                RoundedButton(
                  'Back',
                  onPressed: () {
                    _exit();
                    Navigator.pop(context);
                  },
                ),
                BottomPadding(),
              ],
            ),
          );
        },
      ),
    );
  }

  void _exit() {
    if (model.gameData.game != null)
      model.gameData.game.renderer.refreshSprites();
    model.gameData.resumeTimers();
  }

  Future<bool> _willPopCallback() async {
    if (model != null) _exit();
    return true;
  }
}
