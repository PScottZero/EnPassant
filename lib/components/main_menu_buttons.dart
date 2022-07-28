import 'package:flutter/cupertino.dart';

import '../model/app_model.dart';
import '../views/chess_view.dart';
import 'rounded_button.dart';

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
                  builder: (context) {
                    appModel.gameData.newGame(appModel, context, notify: false);
                    return ChessView(appModel);
                  },
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
