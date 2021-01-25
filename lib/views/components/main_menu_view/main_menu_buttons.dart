import 'package:en_passant/logic/chess_game.dart';
import 'package:en_passant/model/app_model.dart';
import 'package:en_passant/views/components/shared/rounded_button.dart';
import 'package:flutter/cupertino.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../chess_view.dart';
import '../../settings_view.dart';

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
            'Start',
            onPressed: () {
              Navigator.push(
                context,
                CupertinoPageRoute(
                  builder: (context) => ChessView(
                    ChessGame(appModel, context),
                  ),
                ),
              );
            },
          ),
          SizedBox(height: 10),
          Row(
            children: [
              Expanded(
                child: RoundedButton(
                  'GitHub',
                  onPressed: () {
                    openGitHub();
                  },
                ),
              ),
              SizedBox(width: 10),
              Expanded(
                child: RoundedButton(
                  'Settings',
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

  void openGitHub() async {
    const url = 'https://github.com/PScottZero/EnPassant';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }
}
