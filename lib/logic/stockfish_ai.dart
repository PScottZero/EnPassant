import 'package:en_passant/logic/shared_functions.dart';
import 'package:stockfish/stockfish.dart';

import 'chess_board.dart';
import 'chess_game.dart';
import 'chess_piece.dart';
import 'move_classes/move.dart';
import 'move_classes/move_stack_object.dart';

class StockfishAI {
  final pieceCharMap = {
    ChessPieceType.queen: 'q',
    ChessPieceType.rook: 'r',
    ChessPieceType.bishop: 'b',
    ChessPieceType.knight: 'n',
  };
  final stockfish = Stockfish();
  get output {
    return stockfish.stdout;
  }

  StockfishAI(ChessGame game) {
    stockfish.stdout.listen((event) {
      if (event.contains('bestmove')) {
        final bestMove = event.split(' ')[1];
        print(bestMove);
        final move = _moveStringToMove(bestMove);
        game.validMoves = [];
        var meta = push(move, game.board, getMeta: true);
        game.moveCompletion(meta, changeTurn: !meta.promotion);
        if (meta.promotion) {
          game.promote(move.promotionType);
        }
      }
    });
  }

  void dispose() {
    stockfish.dispose();
  }

  void sendPosition(List<MoveStackObject> moveStack) {
    var moveString = UCICommands.POSITION;
    for (final mso in moveStack) {
      moveString += '${_toMoveString(mso)} ';
    }
    print(moveString);
    stockfish.stdin = moveString;
  }

  void aiMove(int difficulty) {
    stockfish.stdin = '${UCICommands.GO} ${difficulty * 1000}';
  }

  Move _moveStringToMove(String moveString) {
    final from = _tileStringToTile(moveString.substring(0, 2));
    final to = _tileStringToTile(moveString.substring(2, 4));
    final promoteType = moveString.length > 4
        ? _promotionStringToChessPiece(moveString[4])
        : ChessPieceType.promotion;
    return Move(from, to, promotionType: promoteType);
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
    if (pieceCharMap.containsKey(type)) {
      return pieceCharMap[type];
    } else {
      return '';
    }
  }

  ChessPieceType _promotionStringToChessPiece(String promotion) {
    if (pieceCharMap.containsValue(promotion)) {
      return pieceCharMap.keys
          .firstWhere((type) => pieceCharMap[type] == promotion);
    } else {
      return ChessPieceType.promotion;
    }
  }
}

class UCICommands {
  static const READY = 'isready';
  static const NEW_GAME = 'ucinewgame';
  static const POSITION = 'position startpos moves ';
  static const GO = 'go movetime';
}
