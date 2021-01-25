import 'move_classes/move.dart';

var openings = [
  [
    // Ruy Lopez
    Move(tileToInt('e2'), tileToInt('e4')),
    Move(tileToInt('e7'), tileToInt('e5')),
    Move(tileToInt('g1'), tileToInt('f3')),
    Move(tileToInt('b8'), tileToInt('c6')),
    Move(tileToInt('f1'), tileToInt('b5')),
  ],
  [
    // Italian Game
    Move(tileToInt('e2'), tileToInt('e4')),
    Move(tileToInt('e7'), tileToInt('e5')),
    Move(tileToInt('g1'), tileToInt('f3')),
    Move(tileToInt('b8'), tileToInt('c6')),
    Move(tileToInt('f1'), tileToInt('c4'))
  ],
  [
    // Sicilian Defense
    Move(tileToInt('e2'), tileToInt('e4')),
    Move(tileToInt('c7'), tileToInt('c5')),
  ],
  [
    // French Defense
    Move(tileToInt('e2'), tileToInt('e4')),
    Move(tileToInt('e7'), tileToInt('e6')),
  ],
  [
    // Caro-Kann Defense
    Move(tileToInt('e2'), tileToInt('e4')),
    Move(tileToInt('c7'), tileToInt('c6')),
  ],
  [
    // Pirc Defense
    Move(tileToInt('e2'), tileToInt('e4')),
    Move(tileToInt('d7'), tileToInt('d6')),
  ],
  [
    // Queen's Gambit
    Move(tileToInt('d2'), tileToInt('d4')),
    Move(tileToInt('d7'), tileToInt('d5')),
    Move(tileToInt('c2'), tileToInt('c4')),
  ],
  [
    // Indian Defense
    Move(tileToInt('d2'), tileToInt('d4')),
    Move(tileToInt('g8'), tileToInt('f6')),
  ],
  [
    // English Opening
    Move(tileToInt('c2'), tileToInt('c4')),
  ],
  [
    // Reti Opening
    Move(tileToInt('g1'), tileToInt('f3')),
  ]
];

int tileToInt(String tile) {
  var file = tile.codeUnitAt(0) - 97;
  var rank = 8 - int.tryParse(tile[1]);
  return rank * 8 + file;
}
