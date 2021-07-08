import 'package:en_passant/model/app_model.dart';
import 'package:en_passant/views/components/rounded_alert_button.dart';
import 'package:en_passant/views/components/gap.dart';
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
            'Restart',
            onConfirm: () {
              appModel.gameData.newGame(appModel, context);
            },
          ),
        ),
        GapRowSmall(),
        Expanded(
          child: RoundedAlertButton(
            'Exit',
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
