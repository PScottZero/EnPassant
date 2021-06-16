import 'package:en_passant/logic/shared_functions.dart';
import 'package:stockfish/stockfish.dart';

import 'chess_piece.dart';
import 'move_classes/move.dart';
import 'move_classes/move_stack_object.dart';

class StockfishAI {
  final stockfish = Stockfish();
  get output {
    return stockfish.stdout;
  }

  void sendPosition(List<MoveStackObject> moveStack) {
    var moveString = UCICommands.POSITION;
    for (final mso in moveStack) {
      moveString += '${_toMoveString(mso)} ';
    }
    print(moveString);
    stockfish.stdin = moveString;
  }

  stockfishOutput() {
    return stockfish.stdout.listen;
  }

  void aiMove() {
    stockfish.stdin = UCICommands.GO;
  }

  Move moveStringToMove(String moveString) {
    final from = moveString.substring(0, 2);
    final to = moveString.substring(2, 4);
    final promoteType = moveString.length > 4
        ? _promotionStringToChessPiece(moveString[4])
        : ChessPieceType.promotion;
    return Move(
      _tileStringToTile(from),
      _tileStringToTile(to),
      promotionType: promoteType,
    );
  }

  int _tileStringToTile(String tileString) {
    final col = tileString.codeUnitAt(0) - 97;
    final row = 8 - int.parse(tileString[1]);
    return row * 8 + col;
  }

  String _toMoveString(MoveStackObject mso) {
    var fromCol = colToChar(tileToCol(mso.move.from));
    final fromRow = 8 - tileToRow(mso.move.from);
    var toCol = colToChar(tileToCol(mso.move.to));
    final toRow = 8 - tileToRow(mso.move.to);
    if (mso.castled) {
      fromCol = 'e';
      if (tileToCol(mso.move.from) == 0 || tileToCol(mso.move.to) == 0) {
        toCol = 'c';
      } else if (tileToCol(mso.move.from) == 7 || tileToCol(mso.move.to) == 7) {
        toCol = 'g';
      }
    }
    return '$fromCol$fromRow$toCol$toRow${_promotionString(mso.move.promotionType)}';
  }

  String _promotionString(ChessPieceType type) {
    switch (type) {
      case ChessPieceType.queen:
        return 'q';
      case ChessPieceType.rook:
        return 'r';
      case ChessPieceType.bishop:
        return 'b';
      case ChessPieceType.knight:
        return 'n';
      default:
        return '';
    }
  }

  ChessPieceType _promotionStringToChessPiece(String promotion) {
    switch (promotion) {
      case 'q':
        return ChessPieceType.queen;
      case 'r':
        return ChessPieceType.rook;
      case 'b':
        return ChessPieceType.bishop;
      case 'n':
        return ChessPieceType.knight;
      default:
        return ChessPieceType.promotion;
    }
  }
}

class UCICommands {
  static const READY = 'is_ready';
  static const NEW_GAME = 'ucinewgame';
  static const POSITION = 'position startpos moves ';
  static const GO = 'go movetime 3000';
}
