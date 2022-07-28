import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../views/settings_view.dart';

class SettingsButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.topRight,
      padding: EdgeInsets.only(
        top: MediaQuery.of(context).padding.top,
      ),
      child: CupertinoButton(
        minSize: 0,
        padding: EdgeInsets.zero,
        child: Icon(
          CupertinoIcons.settings,
          color: Colors.white,
        ),
        onPressed: () {
          Navigator.push(
            context,
            CupertinoPageRoute(
              builder: (context) => SettingsView(),
            ),
          );
        },
      ),
    );
  }
}
