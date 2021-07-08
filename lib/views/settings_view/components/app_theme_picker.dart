import 'package:en_passant/model/app_model.dart';
import 'package:en_passant/model/app_themes.dart';
import 'package:en_passant/views/components/rounded_background.dart';
import 'package:en_passant/views/components/text_variable.dart';
import 'package:en_passant/views/components/picker.dart';
import 'package:en_passant/views/view_constants.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';

class AppThemePicker extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<AppModel>(
      builder: (context, appModel, child) => Column(
        children: [
          Container(
            child: TextSmall('App Theme'),
            padding: EdgeInsets.all(ViewConstants.PADDING_SMALL),
          ),
          RoundedBackground(
            Picker(
              options: themeList.map((theme) => theme.name).toList(),
              selectionIndex: appModel.themePrefs.themeIndex,
              setFunc: appModel.themePrefs.setTheme,
            ),
            height: ViewConstants.PICKER_HEIGHT,
          ),
        ],
      ),
    );
  }
}
