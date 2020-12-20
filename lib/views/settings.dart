import 'package:en_passant/views/components/rounded_button.dart';
import 'package:flutter/cupertino.dart';

import 'components/theme_picker.dart';

class Settings extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: CupertinoColors.black
      ),
      child: Column(
        children: [
          SizedBox(height: 30),
          Text(
            "Settings",
            style: TextStyle(fontSize: 36)
          ),
          SizedBox(height: 30),
          ThemePicker(),
          Spacer(),
          RoundedButton(
            label: "Back",
            color: Color(0xFF00AAFF),
            onPressed: () {
              Navigator.pop(context);
            },
          )
        ],
      ),
      padding: EdgeInsets.all(30),
    );
  }
}