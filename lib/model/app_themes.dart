import 'package:flutter/material.dart';

class AppTheme {
  String name;
  LinearGradient background;
  Color lightTile;
  Color darkTile;
  Color moveHint;
  Color checkHint;

  AppTheme({
    this.name,
    this.background,
    this.lightTile = const Color(0xFFC9B28F),
    this.darkTile = const Color(0xff5b2e1b),
    this.moveHint = const Color(0x550000FF),
    this.checkHint = const Color(0x55FF0000)
  });
}

class AppThemes {
  static List<AppTheme> get themeList {
    var themeList = <AppTheme>[
      AppTheme(
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
        darkTile: Color(0xff2560a5),
        moveHint: Color(0x88ffff00)
      ),
      AppTheme(
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
        darkTile: Color(0xff8800aa),
        moveHint: Color(0x88ffff00),
        checkHint: Color(0x88ff0000),
      ),
      AppTheme(
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
      AppTheme(
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
      AppTheme(
        name: "Red",
        background: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            const Color(0xfff54242),
            const Color(0xff912323)
          ]
        )
      ),
      AppTheme(
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
      AppTheme(
        name: "Black & White",
        background: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            const Color(0xffb2b2b2),
            const Color(0xff4e4e4e),
          ]
        ),
        lightTile: Color(0xffb2b2b2),
        darkTile: Color(0xff808080)
      ),
      AppTheme(
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
        darkTile: Color(0xff6494d6),
        moveHint: Color(0x88aae39e)
      ),
      AppTheme(
        name: "Regal",
        background: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            const Color(0xff2c0078),
            const Color(0xff6d3ac7),
          ]
        ),
        lightTile: Color(0xfff0c76e),
        darkTile: Color(0xff780000),
        moveHint: Color(0x800000ff),
        checkHint: Color(0xffff0000)
      ),
      AppTheme(
        name: "Vaporwave",
        background: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            const Color(0xffff78ed),
            const Color(0xff602af5),
          ]
        ),
        lightTile: Color(0xffff78ed),
        darkTile: Color(0xff602af5),
        moveHint: Color(0x80d1116b),
        checkHint: Color(0x80ff0000)
      ),
      AppTheme(
        name: "Dark",
        background: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            const Color(0xff1e1e1e),
            const Color(0xff2e2e2e),
          ]
        )
      ),
      AppTheme(
        name: "Light",
        background: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            const Color(0xffaeaeae),
            const Color(0xff8e8e8e),
          ]
        )
      )
    ];
    themeList.sort((a, b) => a.name.compareTo(b.name));
    return themeList;
  } 
}
