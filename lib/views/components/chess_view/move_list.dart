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
        height: 160,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(15)),
          color: Color(0x20000000)
        ),
          child: ListView(
            padding: EdgeInsets.all(20),
            controller: scrollController,
            children: [
              Container(
                child: Text(
                  allMoves(gameSettings),
                  style: TextStyle(fontSize: 20)
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
        moveString += index == 0 ? '$turnNumber. ' : '  $turnNumber. ';
      }
      moveString += moveToString(move);
      if (index % 2 == 0) {
        moveString += ' ';
      }
    });
    return moveString;
  }

  String moveToString(Move move) {
    if (move.kingCastle) {
      return 'O-O';
    } else if (move.queenCastle) {
      return 'O-O-O';
    } else {
      String takeString = move.took ? 'x' : '';
      String promotion = move.promotion ? '=Q' : '';
      String check = move.isCheck ? '+' : '';
      String checkmate = move.isCheckmate ? '++': '';
      return '${pieceToChar(move.type)}$takeString' +
        '${colToChar(move.to.col)}${move.to.row + 1}$promotion$check$checkmate';
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