import 'package:en_passant/model/player.dart';
import 'package:en_passant/views/constants/view_constants.dart';
import 'package:flutter/cupertino.dart';

import '../../../components/segmented_control.dart';

class SidePicker extends StatelessWidget {
  final Map<Player, Text> colorOptions = const <Player, Text>{
    Player.player1: Text('White'),
    Player.player2: Text('Black'),
    Player.random: Text('Random')
  };

  final Player playerSide;
  final Function setFunc;

  SidePicker(this.playerSide, this.setFunc);

  @override
  Widget build(BuildContext context) {
    return SegmentedControl<Player>(
      label: ViewConstants.SIDE_STRING,
      options: colorOptions,
      selection: playerSide,
      setFunc: setFunc,
    );
  }
}
