import 'dart:ui';

import 'package:en_passant/logic/ai_move_calculation.dart';
import 'package:en_passant/logic/move_calculation.dart';
import 'package:en_passant/logic/shared_functions.dart';
import 'package:en_passant/model/app_model.dart';
import 'package:en_passant/views/components/main_menu_view/side_picker.dart';
import 'package:flame/game/game.dart';
import 'package:flame/gestures.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';

import 'chess_board.dart';
import 'chess_piece.dart';
import 'move_classes.dart';

class ChessGame extends Game with TapDetector, ChangeNotifier {
  double width;
  double tileSize;
  AppModel appModel;
  ChessBoard board = ChessBoard();

  List<Tile> validMoves = [];
  ChessPiece selectedPiece;
  Tile checkHintTile;

  @override
  void onTapDown(TapDownDetails details) {
    if (appModel.gameOver || !(appModel.isAIsTurn)) {
      var tile = offsetToTile(details.localPosition);
      var touchedPiece = board.pieceAtTile(tile);
      if (selectedPiece != null && touchedPiece != null &&
        touchedPiece.player == selectedPiece.player) {
        if (SharedFunctions.tileIsInTileList(tile: tile, tileList: validMoves)) {
          movePiece(tile);
        } else {
          validMoves = [];
          selectPiece(touchedPiece);
        }
      } else if (selectedPiece == null) {
        selectPiece(touchedPiece);
      } else {
        movePiece(tile);
      }
    }
  }

  @override
  void render(Canvas canvas) {
    drawBoard(canvas);
    drawCheckHint(canvas);
    drawSelectedPieceHint(canvas);
    drawPieces(canvas);
    drawMoveHints(canvas);
  }

  @override
  void update(double t) {
    for (var piece in board.player1Pieces + board.player2Pieces) {
      piece.update(tileSize: tileSize, appModel: appModel);
    }
  }

  void initSpritePositions() {
    for (var piece in board.player1Pieces + board.player2Pieces) {
      piece.initSpritePosition(tileSize, appModel);
    }
  }

  void selectPiece(ChessPiece piece) {
    if (piece != null) {
      if (piece.player == appModel.turn) {
        selectedPiece = piece;
        if (selectedPiece != null) {
          validMoves = MoveCalculation.movesFor(piece: piece, board: board);
        }
        if (validMoves.isEmpty) {
          selectedPiece = null;
        }
      }
    }
  }

  void movePiece(Tile toTile) {
    if (SharedFunctions.tileIsInTileList(tile: toTile, tileList: validMoves)) {
      validMoves = [];
      var move = board.movePiece(from: selectedPiece.tile, to: toTile, getMoveMeta: true);
      moveCompletion(move);
    }
  }

  void aiMove() async {
    await Future.delayed(Duration(milliseconds: 500));
    var move = await AIMoveCalculation.move(
      aiPlayer: appModel.aiTurn,
      aiDifficulty: appModel.aiDifficulty,
      board: board
    );
    if (move.to.row == -1) {
      appModel.endGame();
    } else {
      validMoves = [];
      var finishedMove = board.movePiece(from: move.from, to: move.to, getMoveMeta: true);
      moveCompletion(finishedMove);
    }
  }

  void moveCompletion(Move move) {
    checkHintTile = null;
    var oppositeTurn = SharedFunctions.oppositePlayer(appModel.turn);
    if (MoveCalculation.kingIsInCheck(
      player: oppositeTurn, 
      board: board)
    ) {
      move.meta.isCheck = true;
      checkHintTile = board.kingForPlayer(oppositeTurn).tile;
    }

    if (MoveCalculation.kingIsInCheckmate(
      player: oppositeTurn,
      board: board)
    ) {
      move.meta.isCheck = false;
      move.meta.isCheckmate = true;
      appModel.endGame();
    }

    appModel.addMove(move);
    appModel.changeTurn();
    selectedPiece = null;
    if (appModel.isAIsTurn) {
      aiMove();
    }
  }

  Tile offsetToTile(Offset offset) {
    if (appModel.playingWithAI && appModel.playerSide == PlayerID.player2) {
      return Tile(row: (offset.dy / tileSize).floor(), col: 7 - (offset.dx / tileSize).floor());
    } else {
      return Tile(row: 7 - (offset.dy / tileSize).floor(), col: (offset.dx / tileSize).floor());
    }
  }

  void setSize(Size screenSize) {
    width = screenSize.width - 68;
    tileSize = width / 8;
    resize(Size(width, width));
  }

  void setappModel(AppModel appModel) {
    this.appModel = appModel;
  }

  void drawBoard(Canvas canvas) {
    for (int tileNo = 0; tileNo < 64; tileNo++) {
      canvas.drawRect(
        Rect.fromLTWH(
          (tileNo % 8) * tileSize,
          (tileNo / 8).floor() * tileSize, 
          tileSize, tileSize
        ),
        Paint()..color = (tileNo + (tileNo / 8).floor()) % 2 == 0 ? 
          appModel.theme.lightTile : appModel.theme.darkTile
      );
    }
  }

  void drawPieces(Canvas canvas) {
    for (var piece in board.player1Pieces + board.player2Pieces) {
      piece.sprite.renderRect(canvas, Rect.fromLTWH(
        piece.spriteX + 5,
        piece.spriteY + 5,
        tileSize - 10, tileSize - 10
      ));
    }
  }

  void drawMoveHints(Canvas canvas) {
    for (var move in validMoves) {
      canvas.drawRect(
        Rect.fromLTWH(
          SharedFunctions.getXFromCol(move.col, tileSize, appModel),
          SharedFunctions.getYFromRow(move.row, tileSize, appModel),
          tileSize, tileSize
        ),
        Paint()..color = appModel.theme.moveHint
      );
    }
  }

  void drawCheckHint(Canvas canvas) {
    if (checkHintTile != null) {
      canvas.drawRect(
        Rect.fromLTWH(
          SharedFunctions.getXFromCol(checkHintTile.col, tileSize, appModel),
          SharedFunctions.getYFromRow(checkHintTile.row, tileSize, appModel),
          tileSize, tileSize
        ),
        Paint()..color = appModel.theme.checkHint
      );
    }
  }

  void drawSelectedPieceHint(Canvas canvas) {
    if (selectedPiece != null) {
      canvas.drawCircle(
        Offset(
          SharedFunctions.getXFromCol(selectedPiece.tile.col, tileSize, appModel) + (tileSize / 2),
          SharedFunctions.getYFromRow(selectedPiece.tile.row, tileSize, appModel) + (tileSize / 2)
        ),
        tileSize / 2,
        Paint()..color = appModel.theme.moveHint
      );
    }
  }
}