import 'package:flutter/cupertino.dart';

import '../model/app_model.dart';
import 'gap.dart';
import 'rounded_alert_button.dart';

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
