import 'package:en_passant/settings/game_settings.dart';
import 'package:en_passant/views/main_menu_view.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (context) => GameSettings(),
      child: EnPassantApp()
    )
  );
}

class EnPassantApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.light);
    return CupertinoApp(
      title: 'En Passant',
      theme: CupertinoThemeData(
        brightness: Brightness.dark,
        textTheme: CupertinoTextThemeData(
          textStyle: TextStyle(fontFamily: 'Jura', fontSize: 16),
          pickerTextStyle: TextStyle(fontFamily: 'Jura'),
        )
      ),
      home: MainMenuView(),
    );
  }
}
