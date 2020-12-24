import 'package:en_passant/views/components/main_menu_view/picker.dart';
import 'package:flutter/cupertino.dart';

enum PlayerID { player1, player2 }

class SidePicker extends StatelessWidget {
  final Map<PlayerID, Text> colorOptions = const <PlayerID, Text>{
    PlayerID.player1: Text('White'),
    PlayerID.player2: Text('Black')
  };

  final PlayerID playerSide;
  final Function setFunc;

  SidePicker(this.playerSide, this.setFunc);

  @override
  Widget build(BuildContext context) {
    return Picker<PlayerID>(
      label: 'Side',
      options: colorOptions,
      selection: playerSide,
      setFunc: setFunc,
    );
  }
}