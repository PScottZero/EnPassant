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

class SettingsView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<AppModel>(
      builder: (context, appModel, child) => Container(
        decoration:
            BoxDecoration(gradient: appModel.themePrefs.theme.background),
        padding: EdgeInsets.all(ViewConstants.PADDING_LARGE),
        child: Column(
          children: [
            SizedBox(height: MediaQuery.of(context).padding.top),
            TextLarge(ViewConstants.SETTINGS_STRING),
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
              ViewConstants.BACK_STRING,
              onPressed: () {
                Navigator.pop(context);
              },
            ),
            BottomPadding(),
          ],
        ),
      ),
    );
  }
}
