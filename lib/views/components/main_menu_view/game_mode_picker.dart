import 'package:en_passant/views/components/main_menu_view/picker.dart';
import 'package:flutter/cupertino.dart';

class GameModePicker extends StatelessWidget {
  final Map<int, Text> playerCountOptions = const <int, Text>{
    1: Text('One Player'),
    2: Text('Two Player')
  };

  final int playerCount;
  final Function setFunc;

  GameModePicker(this.playerCount, this.setFunc);

  @override
  Widget build(BuildContext context) {
    return Picker<int>(
      label: 'Game Mode',
      options: playerCountOptions,
      selection: playerCount,
      setFunc: setFunc,
    );
  }
}
