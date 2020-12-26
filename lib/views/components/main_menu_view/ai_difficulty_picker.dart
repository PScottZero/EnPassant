import 'package:en_passant/views/components/main_menu_view/picker.dart';
import 'package:flutter/cupertino.dart';

enum AIDifficulty {
  easy, normal, hard, hardest
}

class AIDifficultyPicker extends StatelessWidget {
  final Map<AIDifficulty, Text> difficultyOptions = {
    AIDifficulty.easy: Text('Easy'),
    AIDifficulty.normal: Text('Normal'),
    AIDifficulty.hard: Text('Hard'),
    AIDifficulty.hardest: Text('Hardest')
  };

  final AIDifficulty aiDifficulty;
  final Function setFunc;

  AIDifficultyPicker(this.aiDifficulty, this.setFunc);

  @override
  Widget build(BuildContext context) {
    return Picker<AIDifficulty>(
      label: 'AI Difficulty',
      options: difficultyOptions,
      selection: aiDifficulty,
      setFunc: setFunc,
    );
  }
}
