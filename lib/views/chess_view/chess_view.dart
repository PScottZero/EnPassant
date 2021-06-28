import 'dart:async';

import 'package:en_passant/model/app_model.dart';
import 'package:en_passant/views/components/bottom_padding.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';

import 'components/chess_board_widget.dart';
import 'components/game_info_and_controls.dart';
import 'components/game_info_and_controls/game_status.dart';
import 'components/promotion_dialog.dart';

class ChessView extends StatefulWidget {
  final AppModel appModel;

  ChessView(this.appModel);

  @override
  _ChessViewState createState() => _ChessViewState(appModel);
}

class _ChessViewState extends State<ChessView> {
  AppModel appModel;

  _ChessViewState(this.appModel);

  @override
  Widget build(BuildContext context) {
    return Consumer<AppModel>(
      builder: (context, appModel, child) {
        if (appModel.gameData.promotionRequested) {
          appModel.gameData.promotionRequested = false;
          WidgetsBinding.instance
              .addPostFrameCallback((_) => _showPromotionDialog(appModel));
        }
        return WillPopScope(
          onWillPop: _willPopCallback,
          child: Container(
            decoration: BoxDecoration(gradient: appModel.themePrefs.theme.background),
            padding: EdgeInsets.all(30),
            child: Column(
              children: [
                Spacer(),
                ChessBoardWidget(appModel),
                SizedBox(height: 30),
                GameStatus(),
                Spacer(),
                GameInfoAndControls(appModel),
                BottomPadding(),
              ],
            ),
          ),
        );
      },
    );
  }

  void _showPromotionDialog(AppModel appModel) {
    showCupertinoDialog(
      context: context,
      builder: (BuildContext context) {
        return PromotionDialog(appModel);
      },
    );
  }

  Future<bool> _willPopCallback() async {
    if (appModel != null) {
      appModel.exitChessView();
    }
    return true;
  }
}
