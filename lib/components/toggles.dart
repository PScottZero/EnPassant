import 'package:flutter/material.dart';

import '../model/app_model.dart';
import 'toggle.dart';

class Toggles extends StatelessWidget {
  final AppModel appModel;

  Toggles(this.appModel);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Toggle(
          label: 'Show Hints',
          toggle: appModel.showHints,
          setFunc: appModel.setShowHints,
        ),
        Toggle(
          label: 'Allow Undo/Redo',
          toggle: appModel.allowUndoRedo,
          setFunc: appModel.setAllowUndoRedo,
        ),
        Toggle(
          label: 'Show Move History',
          toggle: appModel.showMoveHistory,
          setFunc: appModel.setShowMoveHistory,
        ),
        Toggle(
          label: 'Flip Board For Black',
          toggle: appModel.flip,
          setFunc: appModel.setFlipBoard,
        ),
        Toggle(
          label: 'Sound Enabled',
          toggle: appModel.soundEnabled,
          setFunc: appModel.setSoundEnabled,
        ),
      ],
    );
  }
}
