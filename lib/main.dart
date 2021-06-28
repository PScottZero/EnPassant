import 'package:en_passant/model/app_model.dart';
import 'package:en_passant/views/view_constants.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import 'views/main_menu_view/main_menu_view.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (context) => AppModel(),
      child: EnPassantApp(),
    ),
  );
}

class EnPassantApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
    return CupertinoApp(
      title: ViewConstants.APP_NAME,
      theme: CupertinoThemeData(
        brightness: Brightness.dark,
        textTheme: CupertinoTextThemeData(
          textStyle: TextStyle(
            fontFamily: ViewConstants.FONT_NAME,
            fontSize: ViewConstants.TEXT_DEFAULT,
          ),
          pickerTextStyle: TextStyle(
            fontFamily: ViewConstants.FONT_NAME,
          ),
        ),
      ),
      home: MainMenuView(),
    );
  }
}
