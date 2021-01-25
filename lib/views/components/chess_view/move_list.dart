import 'package:en_passant/logic/chess_piece.dart';
import 'package:en_passant/logic/move_calculation/move_classes/move_meta.dart';
import 'package:en_passant/logic/shared_functions.dart';
import 'package:en_passant/model/app_model.dart';
import 'package:en_passant/views/components/main_menu_view/side_picker.dart';
import 'package:en_passant/views/components/shared/text_variable.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';

class MoveList extends StatelessWidget {
  final ScrollController scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) => scrollToBottom());
    return Consumer<AppModel>(
      builder: (context, appModel, child) => Container(
        height: 60,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(15)),
          color: Color(0x20000000),
        ),
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          controller: scrollController,
          padding: EdgeInsets.only(left: 15, right: 15),
          child: Center(
            child: TextRegular(allMoves(appModel)),
          ),
        ),
      ),
    );
  }

  void scrollToBottom() {
    scrollController.jumpTo(scrollController.position.maxScrollExtent);
  }

  String allMoves(AppModel appModel) {
    var moveString = '';
    appModel.moveMetaList.asMap().forEach((index, move) {
      var turnNumber = ((index + 1) / 2).ceil();
      if (index % 2 == 0) {
        moveString += index == 0 ? '$turnNumber. ' : '   $turnNumber. ';
      }
      moveString += moveToString(move);
      if (index % 2 == 0) {
        moveString += ' ';
      }
    });
    if (appModel.gameOver) {
      if (appModel.turn == Player.player1) {
        moveString += ' ';
      }
      if (appModel.stalemate) {
        moveString += '  ½-½';
      } else {
        moveString += appModel.turn == Player.player2 ? '  1-0' : '  0-1';
      }
    }
    return moveString;
  }

  String moveToString(MoveMeta meta) {
    String move;
    if (meta.kingCastle) {
      move = 'O-O';
    } else if (meta.queenCastle) {
      move = 'O-O-O';
    } else {
      String ambiguity =
          meta.rowIsAmbiguous ? '${colToChar(tileToCol(meta.move.from))}' : '';
      ambiguity +=
          meta.colIsAmbiguous ? '${8 - tileToRow(meta.move.from)}' : '';
      String takeString = meta.took ? 'x' : '';
      String promotion = meta.promotion ? '=Q' : '';
      String row = '${8 - tileToRow(meta.move.to)}';
      String col = '${colToChar(tileToCol(meta.move.to))}';
      move = '${pieceToChar(meta.type)}$ambiguity$takeString' +
          '$col$row$promotion';
    }
    String check = meta.isCheck ? '+' : '';
    String checkmate = meta.isCheckmate && !meta.isStalemate ? '#' : '';
    return move + '$check$checkmate';
  }

  String pieceToChar(ChessPieceType type) {
    switch (type) {
      case ChessPieceType.king:
        {
          return 'K';
        }
      case ChessPieceType.queen:
        {
          return 'Q';
        }
      case ChessPieceType.rook:
        {
          return 'R';
        }
      case ChessPieceType.bishop:
        {
          return 'B';
        }
      case ChessPieceType.knight:
        {
          return 'N';
        }
      default:
        {
          return '';
        }
    }
  }

  String colToChar(int col) {
    return String.fromCharCode(97 + col);
  }
}
