import 'package:flame/game.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';

import '../constants/view_constants.dart';
import '../model/app_model.dart';
import 'picker.dart';
import 'piece_preview.dart';
import 'rounded_background.dart';
import 'text_variable.dart';

class PieceThemePicker extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<AppModel>(
      builder: (context, model, child) => Column(
        children: [
          Container(
            child: TextSmall('Piece Theme'),
            padding: EdgeInsets.all(
              ViewConstants.smallPadding,
            ),
          ),
          ClipRRect(
            borderRadius: BorderRadius.circular(
              ViewConstants.borderRadius,
            ),
            child: RoundedBackground(
              child: Row(
                children: [
                  Expanded(
                    child: Picker(
                      options: model.themePrefs.pieceThemes,
                      selectionIndex: model.themePrefs.pieceThemeIndex,
                      setFunc: model.themePrefs.setPieceTheme,
                    ),
                  ),
                  Container(
                    height: ViewConstants.pickerHeight,
                    width: ViewConstants.piecePreviewWidth,
                    child: GameWidget(
                      game: PiecePreview(model.themePrefs),
                    ),
                  ),
                ],
              ),
              height: ViewConstants.pickerHeight,
            ),
          ),
        ],
      ),
    );
  }
}
