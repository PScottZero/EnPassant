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
  ChessBoard board;
  get output {
    return stockfish.stdout;
  }

  StockfishAI(ChessGame game) {
    board = game.board;
    stockfish.stdout.listen((event) {
      if (event.contains('bestmove')) {
        final bestMove = event.split(' ')[1];
        print('BESTMOVE: $bestMove');
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

  Future<void> waitUntilReady() async {
    while (stockfish.state.value != StockfishState.ready) {
      await Future.delayed(Duration(seconds: 1));
    }
  }

  void dispose() {
    stockfish.dispose();
  }

  void sendPosition(List<MoveStackObject> moveStack) {
    var moveString = '${UCICommands.POSITION} ';
    for (final mso in moveStack) {
      moveString += '${_msoToMoveString(mso)} ';
    }
    print('SENT TO STOCKFISH: $moveString');
    stockfish.stdin = moveString;
  }

  void aiMove(int difficulty) {
    stockfish.stdin = '${UCICommands.GO} ${difficulty * 1000}';
  }

  Move _moveStringToMove(String moveString) {
    final fromString = moveString.substring(0, 2);
    final toString = moveString.substring(2, 4);
    final from = _tileStringToTile(fromString);
    var to = _tileStringToTile(toString);
    final promoteType = moveString.length > 4
        ? _promotionStringToChessPiece(moveString[4])
        : ChessPieceType.promotion;
    if (fromString[0] == 'e' && 
      board.tiles[from] != null &&
      board.tiles[from].type == ChessPieceType.king) {
      if (moveString[0] == 'g') {
        to += 1;
      } else if (moveString[0] == 'c') {
        to -= 2;
      }
    }
    return Move(from, to, promotionType: promoteType);
  }

  int _tileStringToTile(String tileString) {
    final col = tileString.codeUnitAt(0) - 97;
    final row = 8 - int.parse(tileString[1]);
    return row * 8 + col;
  }

  String _msoToMoveString(MoveStackObject mso) {
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
  static const POSITION = 'position startpos moves';
  static const GO = 'go movetime';
}
