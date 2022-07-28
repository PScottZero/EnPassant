import 'package:flutter/cupertino.dart';

import '../logic/chess_piece.dart';
import '../logic/constants.dart';
import '../logic/move_classes.dart';
import '../model/app_model.dart';
import 'text_variable.dart';

const PIECE_TYPE_TO_CHAR = <ChessPieceType, String>{
  ChessPieceType.king: 'K',
  ChessPieceType.queen: 'Q',
  ChessPieceType.rook: 'R',
  ChessPieceType.bishop: 'B',
  ChessPieceType.knight: 'N',
  ChessPieceType.pawn: '',
  ChessPieceType.promotion: '?'
};

class MoveList extends StatelessWidget {
  final AppModel appModel;
  final ScrollController scrollController = ScrollController();
  final List<ChessPiece> promotedList = [];

  String get moveString {
    var moveString = '';
    appModel.gameData.game.board.moveStack.asMap().forEach((index, move) {
      var turnNumber = ((index + 1) / 2).ceil();
      if (index % 2 == 0) {
        moveString += index == 0 ? '$turnNumber. ' : '   $turnNumber. ';
      }
      moveString += _moveToString(move);
      if (index % 2 == 0) {
        moveString += ' ';
      }
    });
    if (appModel.gameData.gameOver) {
      if (appModel.gameData.turn.isP1) {
        moveString += ' ';
      }
      if (appModel.gameData.stalemate) {
        moveString += '  ½-½';
      } else {
        moveString += appModel.gameData.turn.isP2 ? '  1-0' : '  0-1';
      }
    }
    return moveString;
  }

  MoveList(this.appModel);

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) => _scrollToRight());
    return Container(
      height: 60,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(30)),
        color: Color(0x20000000),
      ),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        controller: scrollController,
        padding: EdgeInsets.only(left: 15, right: 15),
        child: Center(child: TextRegular(moveString)),
      ),
    );
  }

  void _scrollToRight() {
    if (appModel.gameData.moveListUpdated) {
      scrollController.jumpTo(scrollController.position.maxScrollExtent);
      appModel.gameData.moveListUpdated = false;
    }
  }

  String _moveToString(Move move) {
    String moveString;
    if (move.meta.flags.kingCastle) {
      moveString = 'O-O';
    } else if (move.meta.flags.queenCastle) {
      moveString = 'O-O-O';
    } else {
      String ambiguity = move.meta.flags.rowIsAmbiguous
          ? '${_colToChar(tileToCol(move.from))}'
          : '';
      ambiguity +=
          move.meta.flags.colIsAmbiguous ? '${8 - tileToRow(move.from)}' : '';
      String takeString = move.meta.flags.took ? 'x' : '';
      String promotion = move.meta.flags.promotion
          ? '=${PIECE_TYPE_TO_CHAR[move.meta.promotionType]}'
          : '';
      String row = '${8 - tileToRow(move.to)}';
      String col = '${_colToChar(tileToCol(move.to))}';
      moveString =
          '${PIECE_TYPE_TO_CHAR[getPieceType(move.meta.movedPiece)]}$ambiguity$takeString' +
              '$col$row$promotion';
    }
    String check = move.meta.flags.isCheck ? '+' : '';
    String checkmate =
        move.meta.flags.isCheckmate && !move.meta.flags.isStalemate ? '#' : '';
    if (move.meta.flags.promotion) promotedList.add(move.meta.movedPiece);
    return moveString + '$check$checkmate';
  }

  ChessPieceType getPieceType(ChessPiece piece) {
    return promotedList.contains(piece) ? piece.type : piece.startType;
  }

  String _colToChar(int col) {
    return String.fromCharCode(97 + col);
  }
}
