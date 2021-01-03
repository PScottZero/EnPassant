import 'package:en_passant/model/app_model.dart';
import 'package:en_passant/views/components/settings_view/toggle.dart';
import 'package:en_passant/views/components/shared/rounded_button.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';

import 'components/settings_view/theme_picker.dart';
import 'components/shared/bottom_padding.dart';
import 'components/shared/text_variable.dart';

class SettingsView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<AppModel>(
      builder: (context, appModel, child) => Container(
        decoration: BoxDecoration(gradient: appModel.theme.background),
        padding: EdgeInsets.all(30),
        child: Column(
          children: [
            SizedBox(height: MediaQuery.of(context).padding.top),
            TextLarge('Settings'),
            SizedBox(height: 30),
            ThemePicker(),
            SizedBox(height: 30),
            Toggle(
              'Show Move History',
              toggle: appModel.showMoveHistory,
              setFunc: appModel.setShowMoveHistory
            ),
            Toggle(
              'Sound Enabled',
              toggle: appModel.soundEnabled,
              setFunc: appModel.setSoundEnabled
            ),
            Spacer(),
            RoundedButton('Back', onPressed: () {
              Navigator.pop(context);
            }),
            BottomPadding()
          ],
        )
      )
    );
  }
}