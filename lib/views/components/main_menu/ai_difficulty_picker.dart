import 'package:en_passant/views/components/shared/picker.dart';
import 'package:flutter/cupertino.dart';

enum AIDifficulty { easy, normal, hard }

class AIDifficultyPicker extends StatelessWidget {
  final Map<AIDifficulty, Text> difficultyOptions = const <AIDifficulty, Text>{
    AIDifficulty.easy: Text('Easy'),
    AIDifficulty.normal: Text('Normal'),
    AIDifficulty.hard: Text('Hard')
  };

  final AIDifficulty aiDifficulty;
  final Function setFunc;

  AIDifficultyPicker(this.aiDifficulty, this.setFunc);

  @override
  Widget build(BuildContext context) {
    return Picker<AIDifficulty>(
      label: "AI Difficulty",
      options: difficultyOptions,
      selection: aiDifficulty,
      setFunc: setFunc,
    );
  }
}
