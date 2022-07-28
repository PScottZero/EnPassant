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
      builder: (context, appModel, child) => Column(
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
              Row(
                children: [
                  Expanded(
                    child: Picker(
                      options: appModel.themePrefs.pieceThemes,
                      selectionIndex: appModel.themePrefs.pieceThemeIndex,
                      setFunc: appModel.themePrefs.setPieceTheme,
                    ),
                  ),
                  Container(
                    height: ViewConstants.pickerHeight,
                    width: ViewConstants.PIECE_PREVIEW_WIDTH,
                    child: GameWidget(
                      game: PiecePreview(appModel),
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
