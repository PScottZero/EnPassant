import 'package:en_passant/logic/chess_piece.dart';
import 'package:en_passant/logic/move_calculation/move_classes.dart';
import 'package:en_passant/logic/shared_functions.dart';
import 'package:en_passant/model/app_model.dart';
import 'package:en_passant/views/components/text_variable.dart';
import 'package:flutter/cupertino.dart';

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
      if (appModel.gameData.turn == Player.player1) {
        moveString += ' ';
      }
      if (appModel.gameData.stalemate) {
        moveString += '  ½-½';
      } else {
        moveString +=
            appModel.gameData.turn == Player.player2 ? '  1-0' : '  0-1';
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
    if (appModel.moveListUpdated) {
      scrollController.jumpTo(scrollController.position.maxScrollExtent);
      appModel.moveListUpdated = false;
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
          '${PIECE_TYPE_TO_CHAR[move.meta.type]}$ambiguity$takeString' +
              '$col$row$promotion';
    }
    String check = move.meta.flags.isCheck ? '+' : '';
    String checkmate =
        move.meta.flags.isCheckmate && !move.meta.flags.isStalemate ? '#' : '';
    return moveString + '$check$checkmate';
  }

  String _colToChar(int col) {
    return String.fromCharCode(97 + col);
  }
}
