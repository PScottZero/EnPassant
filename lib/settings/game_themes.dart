import 'package:flutter/material.dart';

class GameTheme {
  String name;
  LinearGradient background;

  GameTheme({this.name, this.background});
}

class GameThemes {
  static var themeList = <GameTheme>[
    GameTheme(
      name: "Green",
      background: LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [
          const Color(0xff25804f),
          const Color(0xff00584f),
        ]
      )
    ),
    GameTheme(
      name: "Opal",
      background: LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [
          const Color(0xffb5b8c9),
          const Color(0xffc7958a),
          const Color(0xffdbd879),
          const Color(0xff96cf8a),
          const Color(0xff6a81df),
          const Color(0xff507fc2)
        ]
      )
    ),
  ];
}

