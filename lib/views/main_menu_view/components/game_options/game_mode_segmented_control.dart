import 'package:en_passant/views/constants/view_constants.dart';
import 'package:flutter/cupertino.dart';

import '../../../components/segmented_control.dart';

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
    return SegmentedControl<int>(
      label: ViewConstants.GAME_MODE_STRING,
      options: playerCountOptions,
      selection: playerCount,
      setFunc: setFunc,
    );
  }
}
