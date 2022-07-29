import 'package:flutter/cupertino.dart';

import '../../../components/segmented_control.dart';

class AIDifficultyPicker extends StatelessWidget {
  final Map<int, Text> difficultyOptions = const {
    1: Text('1'),
    2: Text('2'),
    3: Text('3'),
    4: Text('4'),
    5: Text('5'),
    6: Text('6')
  };

  final int aiDifficulty;
  final Function(int) setFunc;

  const AIDifficultyPicker({
    Key? key,
    required this.aiDifficulty,
    required this.setFunc,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SegmentedControl<int>(
      label: 'AI Difficulty',
      options: difficultyOptions,
      selection: aiDifficulty,
      setFunc: setFunc,
    );
  }
}
