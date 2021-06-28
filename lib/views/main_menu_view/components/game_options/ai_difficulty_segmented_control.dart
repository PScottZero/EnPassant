import 'package:en_passant/views/constants/view_constants.dart';
import 'package:flutter/cupertino.dart';

import '../../../components/segmented_control.dart';

class AIDifficultyPicker extends StatelessWidget {
  final Map<int, Text> difficultyOptions = {
    1: Text('1'),
    2: Text('2'),
    3: Text('3'),
    4: Text('4'),
    5: Text('5'),
    6: Text('6')
  };

  final int aiDifficulty;
  final Function setFunc;

  AIDifficultyPicker(this.aiDifficulty, this.setFunc);

  @override
  Widget build(BuildContext context) {
    return SegmentedControl<int>(
      label: ViewConstants.AI_DIFFICULTY_STRING,
      options: difficultyOptions,
      selection: aiDifficulty,
      setFunc: setFunc,
    );
  }
}
