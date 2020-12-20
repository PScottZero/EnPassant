import 'package:flutter/material.dart';

class GameTheme {
  String name;
  LinearGradient background;

  GameTheme({this.name, this.background});
}

class GameThemes {
  static var themeList = <GameTheme>[
    GameTheme(
      name: "Green (Default)",
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
      name: "Bismuth",
      background: LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [
          const Color(0xff2560a5),
          const Color(0xff2f6e72),
          const Color(0xff4faa55),
          const Color(0xffe6de50),
          const Color(0xffdb70eb),
        ]
      )
    ),
    GameTheme(
      name: "Blue",
      background: LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [
          const Color(0xff236e91),
          const Color(0xff0f4964),
        ]
      )
    ),
    GameTheme(
      name: "Candy",
      background: LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [
          const Color(0xff8934eb),
          const Color(0xff004f80),
        ]
      )
    ),
    GameTheme(
      name: "Iridescent",
      background: LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [
          const Color(0xffb2b2b2),
          const Color(0xffb24d00),
          const Color(0xffb2004d),
          const Color(0xff004db2),
          const Color(0xff4d4d4d)
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
    GameTheme(
      name: "Red",
      background: LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [
          const Color(0xfff54242),
          const Color(0xff912323)
        ]
      )
    )
  ];
}
