import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';

import '../constants/view_constants.dart';
import '../model/app_model.dart';
import '../model/app_themes.dart';
import 'picker.dart';
import 'rounded_background.dart';
import 'text_variable.dart';

class AppThemePicker extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<AppModel>(
      builder: (context, appModel, child) => Column(
        children: [
          Container(
            child: TextSmall('App Theme'),
            padding: EdgeInsets.all(ViewConstants.smallPadding),
          ),
          RoundedBackground(
            height: ViewConstants.pickerHeight,
            child: Picker(
              options: themeList.map((theme) => theme.name).toList(),
              selectionIndex: appModel.themePrefs.themeIndex,
              setFunc: appModel.themePrefs.setTheme,
            ),
          ),
        ],
      ),
    );
  }
}
