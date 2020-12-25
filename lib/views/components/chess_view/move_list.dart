import 'package:en_passant/logic/chess_piece.dart';
import 'package:en_passant/logic/move_classes.dart';
import 'package:en_passant/settings/game_settings.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';

class MoveList extends StatelessWidget {
  final ScrollController scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) => scrollToBottom());
    return Consumer<GameSettings>(
      builder: (context, gameSettings, child) => Container(
        height: 60,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(15)),
          color: Color(0x20000000)
        ),
          child: ListView(
            scrollDirection: Axis.horizontal,
            controller: scrollController,
            padding: EdgeInsets.only(left: 15, right: 15),
            children: [
              Center(
                child: Text(
                  allMoves(gameSettings),
                  style: TextStyle(fontSize: 24)
                )
              )
            ],
          )
      )
    );
  }

  void scrollToBottom() {
    scrollController.jumpTo(scrollController.position.maxScrollExtent);
  }

  String allMoves(GameSettings gameSettings) {
    var moveString = '';
    gameSettings.moves.asMap().forEach((index, move) {
      var turnNumber = ((index + 1) / 2).ceil();
      if (index % 2 == 0) {
        moveString += index == 0 ? '$turnNumber. ' : '   $turnNumber. ';
      }
      moveString += moveToString(move);
      if (index % 2 == 0) {
        moveString += ' ';
      }
    });
    return moveString;
  }

  String moveToString(Move move) {
    if (move.meta.kingCastle) {
      return 'O-O';
    } else if (move.meta.queenCastle) {
      return 'O-O-O';
    } else {
      String takeString = move.meta.took ? 'x' : '';
      String promotion = move.meta.promotion ? '=Q' : '';
      String check = move.meta.isCheck ? '+' : '';
      String checkmate = move.meta.isCheckmate ? '++': '';
      String row = '${move.to.row + 1}';
      String col = '${colToChar(move.to.col)}';
      if (move.meta.colIsAmbiguous) {
        row += '${move.from.row + 1}';
      } else if (move.meta.rowIsAmbiguous) {
        col += '${colToChar(move.from.col)}';
      }
      return '${pieceToChar(move.meta.type)}$takeString' +
        '$col$row$promotion$check$checkmate';
    }
  }

  String pieceToChar(ChessPieceType type) {
    switch (type) {
      case ChessPieceType.king: { return 'K'; }
      case ChessPieceType.queen: { return 'Q'; }
      case ChessPieceType.rook: { return 'R'; }
      case ChessPieceType.bishop: { return 'B'; }
      case ChessPieceType.knight: { return 'N'; }
      default: { return ''; }
    }
  }

  String colToChar(int col) {
    return String.fromCharCode(97 + col);
  }
}