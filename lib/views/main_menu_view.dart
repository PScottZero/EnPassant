import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';

import '../components/bottom_padding.dart';
import '../components/game_options.dart';
import '../components/gap.dart';
import '../components/rounded_button.dart';
import '../components/settings_button.dart';
import '../constants/view_constants.dart';
import '../model/app_model.dart';
import 'chess_view.dart';

class MainMenuView extends StatefulWidget {
  @override
  _MainMenuViewState createState() => _MainMenuViewState();
}

class _MainMenuViewState extends State<MainMenuView> {
  @override
  Widget build(BuildContext context) {
    return Consumer<AppModel>(
      builder: (context, model, child) {
        return Container(
          decoration: BoxDecoration(
            gradient: model.themePrefs.theme.background,
          ),
          padding: EdgeInsets.all(ViewConstants.largePadding),
          child: Stack(
            children: [
              Column(
                children: [
                  Container(
                    padding: EdgeInsets.only(
                      top: MediaQuery.of(context).padding.top,
                    ),
                    child: Image.asset('assets/images/logo.png'),
                  ),
                  GapColumnSmall(),
                  GameOptions(model),
                  GapColumnSmall(),
                  Container(
                    width: double.infinity,
                    child: Column(
                      children: [
                        RoundedButton(
                          'Start',
                          onPressed: () {
                            Navigator.push(
                              context,
                              CupertinoPageRoute(
                                builder: (context) {
                                  model.gameData.newGame(notify: false);
                                  return ChessView();
                                },
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                  BottomPadding(),
                ],
              ),
              SettingsButton(),
            ],
          ),
        );
      },
    );
  }
}
