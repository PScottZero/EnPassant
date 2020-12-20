import 'package:en_passant/views/components/shared/rounded_button.dart';
import 'package:flutter/cupertino.dart';

import '../../chess_widget.dart';
import '../../settings.dart';

class MainMenuButtons extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      child: Column(
        children: [
          RoundedButton(
            label: "Start",
            onPressed: () {
              Navigator.push(context,
                CupertinoPageRoute(builder: (context) => ChessWidget())
              );
            },
          ),
          SizedBox(height: 10),
          Row(
            children: [
              Expanded(
                child: RoundedButton(label: "Load Game", onPressed: () {}),
              ),
              SizedBox(width: 10),
              Expanded(
                child: RoundedButton(label: "Settings", onPressed: () {
                  Navigator.push(context,
                    CupertinoPageRoute(builder: (context) => Settings())
                  );
                }),
              )
            ],
          )
        ],
      ),
    );
  }
}