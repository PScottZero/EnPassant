import 'dart:io';

import 'package:en_passant/model/app_model.dart';
import 'package:flutter/material.dart';

import 'toggle.dart';

class Toggles extends StatelessWidget {
  final AppModel appModel;

  Toggles(this.appModel);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Toggle(
          'Show Hints',
          toggle: appModel.showHints,
          setFunc: appModel.setShowHints,
        ),
        Toggle(
          'Allow Undo/Redo',
          toggle: appModel.allowUndoRedo,
          setFunc: appModel.setAllowUndoRedo,
        ),
        Toggle(
          'Show Move History',
          toggle: appModel.showMoveHistory,
          setFunc: appModel.setShowMoveHistory,
        ),
        Toggle(
          'Flip Board For Black',
          toggle: appModel.flip,
          setFunc: appModel.setFlipBoard,
        ),
        Platform.isAndroid
            ? Toggle(
                'Sound Enabled',
                toggle: appModel.soundEnabled,
                setFunc: appModel.setSoundEnabled,
              )
            : Container(),
      ],
    );
  }
}
