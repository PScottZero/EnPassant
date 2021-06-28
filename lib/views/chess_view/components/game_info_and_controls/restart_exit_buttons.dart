import 'package:en_passant/model/app_model.dart';
import 'package:en_passant/views/chess_view/components/game_info_and_controls/rounded_alert_button.dart';
import 'package:en_passant/views/components/gap.dart';
import 'package:en_passant/views/constants/view_constants.dart';
import 'package:flutter/cupertino.dart';

class RestartExitButtons extends StatelessWidget {
  final AppModel appModel;

  RestartExitButtons(this.appModel);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: RoundedAlertButton(
            ViewConstants.RESTART_STRING,
            onConfirm: () {
              appModel.gameData.newGame(appModel, context);
            },
          ),
        ),
        GapRowSmall(),
        Expanded(
          child: RoundedAlertButton(
            ViewConstants.EXIT_STRING,
            onConfirm: () {
              appModel.exitChessView();
              Navigator.pop(context);
            },
          ),
        ),
      ],
    );
  }
}
