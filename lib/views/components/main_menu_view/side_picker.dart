import 'package:en_passant/views/components/main_menu_view/picker.dart';
import 'package:flutter/cupertino.dart';

enum Player { player1, player2 }

class SidePicker extends StatelessWidget {
  final Map<Player, Text> colorOptions = const <Player, Text>{
    Player.player1: Text('White'),
    Player.player2: Text('Black')
  };

  final Player playerSide;
  final Function setFunc;

  SidePicker(this.playerSide, this.setFunc);

  @override
  Widget build(BuildContext context) {
    return Picker<Player>(
      label: 'Side',
      options: colorOptions,
      selection: playerSide,
      setFunc: setFunc,
    );
  }
}
