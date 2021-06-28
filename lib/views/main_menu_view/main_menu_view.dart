import 'package:en_passant/model/app_model.dart';
import 'package:en_passant/views/components/bottom_padding.dart';
import 'package:en_passant/views/view_constants.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';

import 'components/app_logo.dart';
import 'components/game_options.dart';
import 'components/main_menu_buttons.dart';

class MainMenuView extends StatefulWidget {
  @override
  _MainMenuViewState createState() => _MainMenuViewState();
}

class _MainMenuViewState extends State<MainMenuView> {
  @override
  Widget build(BuildContext context) {
    return Consumer<AppModel>(
      builder: (context, appModel, child) {
        return Container(
          decoration:
              BoxDecoration(gradient: appModel.themePrefs.theme.background),
          padding: EdgeInsets.all(ViewConstants.PADDING),
          child: Column(
            children: [
              AppLogo(),
              SizedBox(height: ViewConstants.SMALL_GAP),
              GameOptions(appModel),
              SizedBox(height: ViewConstants.SMALL_GAP),
              MainMenuButtons(appModel),
              BottomPadding(),
            ],
          ),
        );
      },
    );
  }
}