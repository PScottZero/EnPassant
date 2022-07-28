import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';

import '../components/bottom_padding.dart';
import '../components/chess_board_widget.dart';
import '../components/game_info_and_controls.dart';
import '../components/game_status.dart';
import '../components/gap.dart';
import '../components/promotion_dialog.dart';
import '../components/settings_button.dart';
import '../constants/view_constants.dart';
import '../model/app_model.dart';

class ChessView extends StatefulWidget {
  ChessView({Key? key});

  @override
  _ChessViewState createState() => _ChessViewState();
}

class _ChessViewState extends State<ChessView> {
  AppModel? _model;

  @override
  Widget build(BuildContext context) {
    return Consumer<AppModel>(
      builder: (context, model, child) {
        _model = model;
        if (model.gameData.promotionRequested) {
          model.gameData.promotionRequested = false;
          WidgetsBinding.instance
              .addPostFrameCallback((_) => _showPromotionDialog());
        }
        return WillPopScope(
          onWillPop: _willPopCallback,
          child: Stack(
            children: [
              Container(
                decoration: BoxDecoration(
                  gradient: model.themePrefs.theme.background,
                ),
                padding: EdgeInsets.all(ViewConstants.largePadding),
                child: Stack(
                  children: [
                    Column(
                      children: [
                        Spacer(),
                        ChessBoardWidget(model),
                        GapColumnLarge(),
                        GameStatus(),
                        Spacer(),
                        GameInfoAndControls(model),
                        BottomPadding(),
                      ],
                    ),
                    SettingsButton(),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  void _showPromotionDialog() => _model != null
      ? showCupertinoDialog(
          context: context,
          builder: (BuildContext context) {
            return PromotionDialog(_model!);
          },
        )
      : null;

  Future<bool> _willPopCallback() async {
    if (_model != null) _model!.exitChessView();
    return true;
  }
}
