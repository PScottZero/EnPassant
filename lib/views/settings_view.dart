import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';

import '../components/app_theme_picker.dart';
import '../components/bottom_padding.dart';
import '../components/gap.dart';
import '../components/piece_theme_picker.dart';
import '../components/rounded_button.dart';
import '../components/text_variable.dart';
import '../components/toggles.dart';
import '../constants/view_constants.dart';
import '../model/app_model.dart';

class SettingsView extends StatefulWidget {
  @override
  _SettingsViewState createState() => _SettingsViewState();
}

class _SettingsViewState extends State<SettingsView> {
  AppModel? _model;
  bool init = true;

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _willPopCallback,
      child: Consumer<AppModel>(
        builder: (context, model, child) {
          if (init) {
            model.gameData.pauseTimers();
            _model = model;
            init = false;
          }
          return Container(
            decoration: BoxDecoration(
              gradient: model.themePrefs.theme.background,
            ),
            padding: EdgeInsets.all(ViewConstants.largePadding),
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
                      Toggles(model),
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
    if (_model?.gameData.game != null)
      _model!.gameData.game!.renderer.refreshSprites();
    _model!.gameData.resumeTimers();
  }

  Future<bool> _willPopCallback() async {
    if (_model != null) _exit();
    return true;
  }
}
