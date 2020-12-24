import 'package:en_passant/views/components/shared/picker.dart';
import 'package:flutter/cupertino.dart';

class AIDifficultyPicker extends StatelessWidget {
  Map<int, Text> get difficultyOptions {
    var options = Map<int, Text>();
    for (int index = 1; index <= 4; index++) {
      options.putIfAbsent(index, () => Text('$index'));
    }
    return options;
  }

  final int aiDifficulty;
  final Function setFunc;

  AIDifficultyPicker(this.aiDifficulty, this.setFunc);

  @override
  Widget build(BuildContext context) {
    return Picker<int>(
      label: "AI Difficulty",
      options: difficultyOptions,
      selection: aiDifficulty,
      setFunc: setFunc,
    );
  }
}
