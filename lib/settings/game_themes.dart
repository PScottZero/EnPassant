import 'package:flutter/material.dart';

class GameTheme {
  String name;
  LinearGradient background;
  Color lightTile;
  Color darkTile;

  GameTheme({
    this.name,
    this.background,
    this.lightTile = const Color(0xFFC9B28F),
    this.darkTile = const Color(0xFF857050)
  });
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
      ),
      lightTile: Color(0xff4faa55),
      darkTile: Color(0xff2560a5)
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
      ),
      lightTile: Color(0xff0088ff),
      darkTile: Color(0xff8800aa)
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
      ),
      lightTile: Color(0xffabc0d1),
      darkTile: Color(0xff7991a6)
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
      ),
      lightTile: Color(0xffd1d7e0),
      darkTile: Color(0xff6494d6)
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
