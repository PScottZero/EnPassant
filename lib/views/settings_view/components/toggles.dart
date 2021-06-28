import 'dart:io';

import 'package:en_passant/model/app_model.dart';
import 'package:en_passant/views/constants/view_constants.dart';
import 'package:flutter/material.dart';

import '../../components/toggle.dart';

class Toggles extends StatelessWidget {
  final AppModel appModel;

  Toggles(this.appModel);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Toggle(
          ViewConstants.SHOW_HINTS_STRING,
          toggle: appModel.showHints,
          setFunc: appModel.setShowHints,
        ),
        Toggle(
          ViewConstants.UNDO_REDO_STRING,
          toggle: appModel.allowUndoRedo,
          setFunc: appModel.setAllowUndoRedo,
        ),
        Toggle(
          ViewConstants.MOVE_HISTORY_STRING,
          toggle: appModel.showMoveHistory,
          setFunc: appModel.setShowMoveHistory,
        ),
        Toggle(
          ViewConstants.FLIP_STRING,
          toggle: appModel.flip,
          setFunc: appModel.setFlipBoard,
        ),
        Platform.isAndroid
            ? Toggle(
                ViewConstants.SOUND_ENABLED_STRING,
                toggle: appModel.soundEnabled,
                setFunc: appModel.setSoundEnabled,
              )
            : Container(),
      ],
    );
  }
}
