import 'package:en_passant/model/app_model.dart';
import 'package:en_passant/views/chess_view/chess_view.dart';
import 'package:en_passant/views/components/gap.dart';
import 'package:en_passant/views/components/rounded_button.dart';
import 'package:en_passant/views/settings_view/settings_view.dart';
import 'package:en_passant/views/view_constants.dart';
import 'package:flutter/cupertino.dart';
import 'package:url_launcher/url_launcher.dart';

class MainMenuButtons extends StatelessWidget {
  final AppModel appModel;

  MainMenuButtons(this.appModel);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      child: Column(
        children: [
          RoundedButton(
            ViewConstants.START_STRING,
            onPressed: () {
              Navigator.push(
                context,
                CupertinoPageRoute(
                  builder: (context) {
                    appModel.gameData.newGame(appModel, context, notify: false);
                    return ChessView(appModel);
                  },
                ),
              );
            },
          ),
          GapColumnSmall(),
          Row(
            children: [
              Expanded(
                child: RoundedButton(
                  ViewConstants.GITHUB_STRING,
                  onPressed: () {
                    _openGitHub();
                  },
                ),
              ),
              GapRowSmall(),
              Expanded(
                child: RoundedButton(
                  ViewConstants.SETTINGS_STRING,
                  onPressed: () {
                    Navigator.push(
                      context,
                      CupertinoPageRoute(
                        builder: (context) => SettingsView(),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _openGitHub() async {
    if (await canLaunch(ViewConstants.GITHUB_URL)) {
      await launch(ViewConstants.GITHUB_URL);
    } else {
      throw 'Could not launch ${ViewConstants.GITHUB_URL}';
    }
  }
}
