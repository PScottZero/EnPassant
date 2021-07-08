import 'package:en_passant/model/app_model.dart';
import 'package:en_passant/views/components/rounded_background.dart';
import 'package:en_passant/views/components/text_variable.dart';
import 'package:en_passant/views/components/picker.dart';
import 'package:en_passant/views/view_constants.dart';
import 'package:flame/game.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';

import 'piece_theme_picker/piece_preview.dart';

class PieceThemePicker extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<AppModel>(
      builder: (context, appModel, child) => Column(
        children: [
          Container(
            child: TextSmall('Piece Theme'),
            padding: EdgeInsets.all(
              ViewConstants.PADDING_SMALL,
            ),
          ),
          ClipRRect(
            borderRadius: BorderRadius.circular(
              ViewConstants.BORDER_RADIUS,
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
                    height: ViewConstants.PICKER_HEIGHT,
                    width: ViewConstants.PIECE_PREVIEW_WIDTH,
                    child: GameWidget(
                      game: PiecePreview(appModel),
                    ),
                  ),
                ],
              ),
              height: ViewConstants.PICKER_HEIGHT,
            ),
          ),
        ],
      ),
    );
  }
}
