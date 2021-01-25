import 'package:en_passant/model/app_model.dart';
import 'package:flutter/cupertino.dart';

class LoadingAnimation extends StatelessWidget {
  final AppModel appModel;

  LoadingAnimation(this.appModel);

  @override
  Widget build(BuildContext context) {
    return !appModel.gameOver && appModel.playerCount == 1 && appModel.isAIsTurn
        ? CupertinoActivityIndicator(radius: 12)
        : Container();
  }
}
