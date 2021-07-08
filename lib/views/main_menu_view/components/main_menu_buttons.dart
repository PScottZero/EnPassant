import 'package:en_passant/model/app_model.dart';
import 'package:en_passant/views/chess_view/chess_view.dart';
import 'package:en_passant/views/components/rounded_button.dart';
import 'package:flutter/cupertino.dart';

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
