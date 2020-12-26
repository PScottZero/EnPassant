import 'package:en_passant/views/components/shared/rounded_button.dart';
import 'package:flutter/cupertino.dart';

import '../../chess_view.dart';
import '../../settings_view.dart';

class MainMenuButtons extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      child: Column(
        children: [
          RoundedButton(
            label: 'Start',
            onPressed: () {
              Navigator.push(context,
                CupertinoPageRoute(builder: (context) => ChessView())
              );
            },
          ),
          SizedBox(height: 10),
          RoundedButton(label: 'Settings', onPressed: () {
            Navigator.push(context,
              CupertinoPageRoute(builder: (context) => SettingsView())
            );
          })
        ],
      ),
    );
  }
}