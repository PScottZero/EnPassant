import 'package:flutter/cupertino.dart';

import '../../../components/segmented_control.dart';
import '../logic/player.dart';

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
      label: 'Side',
      options: colorOptions,
      selection: playerSide,
      setFunc: setFunc,
    );
  }
}