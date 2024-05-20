import 'dart:async';
import 'package:flutter/foundation.dart';
import 'chess_piece.dart';

enum Player { white, black }

class ChessGameProvider extends ChangeNotifier {
  List<List<ChessPiece?>> board = List.generate(8, (_) => List.filled(8, null));
  ChessPiece? selectedPiece;
  int? selectedRow;
  int? selectedCol;
  String whitePlayer = '';
  String blackPlayer = '';
  List<ChessPiece> whiteCaptured = [];
  List<ChessPiece> blackCaptured = [];
  Player currentPlayer = Player.white;
  bool gameOver = false;
  Map<Player, Duration> playerTimes = {
    Player.white: Duration(minutes: 5),
    Player.black: Duration(minutes: 5),
  };
  Stopwatch whiteTimer = Stopwatch();
  Stopwatch blackTimer = Stopwatch();
  Timer? _timer;

  ChessGameProvider() {
    _initializeBoard();
    _startTimer();
  }

  void _initializeBoard() {
    // Set up pieces for white and black players
    for (int col = 0; col < 8; col++) {
      board[1][col] = ChessPiece(type: PieceType.pawn, color: PieceColor.black);
      board[6][col] = ChessPiece(type: PieceType.pawn, color: PieceColor.white);
    }

    List<PieceType> backRank = [
      PieceType.rook,
      PieceType.knight,
      PieceType.bishop,
      PieceType.queen,
      PieceType.king,
      PieceType.bishop,
      PieceType.knight,
      PieceType.rook
    ];

    for (int col = 0; col < 8; col++) {
      board[0][col] = ChessPiece(type: backRank[col], color: PieceColor.black);
      board[7][col] = ChessPiece(type: backRank[col], color: PieceColor.white);
    }

    whiteTimer.start();
  }

  void setPlayerNames(String white, String black) {
    whitePlayer = white;
    blackPlayer = black;
    notifyListeners();
  }

  void selectSquare(int row, int col) {
    if (gameOver) return;

    if (selectedPiece == null && board[row][col] != null) {
      if (board[row][col]!.color == _currentPlayerColor()) {
        selectedPiece = board[row][col];
        selectedRow = row;
        selectedCol = col;
      }
    } else if (selectedPiece != null) {
      if (_isValidMove(selectedRow!, selectedCol!, row, col)) {
        if (board[row][col] != null) {
          if (selectedPiece!.color == PieceColor.white) {
            blackCaptured.add(board[row][col]!);
          } else {
            whiteCaptured.add(board[row][col]!);
          }
        }
        board[row][col] = selectedPiece;
        board[selectedRow!][selectedCol!] = null;
        selectedPiece = null;
        _endTurn();
      }
    }
  }

  PieceColor _currentPlayerColor() {
    return currentPlayer == Player.white ? PieceColor.white : PieceColor.black;
  }

  void _endTurn() {
    if (currentPlayer == Player.white) {
      whiteTimer.stop();
      blackTimer.start();
      currentPlayer = Player.black;
    } else {
      blackTimer.stop();
      whiteTimer.start();
      currentPlayer = Player.white;
    }
    notifyListeners();
  }

  bool _isValidMove(int fromRow, int fromCol, int toRow, int toCol) {
    final piece = board[fromRow][fromCol];
    if (piece == null) return false;

    final targetPiece = board[toRow][toCol];
    if (targetPiece != null && targetPiece.color == piece.color) return false;

    switch (piece.type) {
      case PieceType.pawn:
        return _isValidPawnMove(fromRow, fromCol, toRow, toCol, piece.color);
      case PieceType.rook:
        return _isValidRookMove(fromRow, fromCol, toRow, toCol);
      case PieceType.knight:
        return _isValidKnightMove(fromRow, fromCol, toRow, toCol);
      case PieceType.bishop:
        return _isValidBishopMove(fromRow, fromCol, toRow, toCol);
      case PieceType.queen:
        return _isValidQueenMove(fromRow, fromCol, toRow, toCol);
      case PieceType.king:
        return _isValidKingMove(fromRow, fromCol, toRow, toCol);
    }
  }

  bool _isValidPawnMove(int fromRow, int fromCol, int toRow, int toCol, PieceColor color) {
    int direction = color == PieceColor.white ? -1 : 1;
    if (fromCol == toCol) {
      if (board[toRow][toCol] == null && (toRow == fromRow + direction)) {
        return true;
      }
      if (fromRow == (color == PieceColor.white ? 6 : 1) &&
          board[toRow][toCol] == null &&
          board[toRow - direction][toCol] == null &&
          toRow == fromRow + (2 * direction)) {
        return true;
      }
    } else if ((toCol == fromCol + 1 || toCol == fromCol - 1) &&
        toRow == fromRow + direction &&
        board[toRow][toCol] != null) {
      return true;
    }
    return false;
  }

  bool _isValidRookMove(int fromRow, int fromCol, int toRow, int toCol) {
    if (fromRow != toRow && fromCol != toCol) return false;
    if (fromRow == toRow) {
      for (int col = fromCol < toCol ? fromCol + 1 : fromCol - 1; col != toCol; col += fromCol < toCol ? 1 : -1) {
        if (board[fromRow][col] != null) return false;
      }
    } else {
      for (int row = fromRow < toRow ? fromRow + 1 : fromRow - 1; row != toRow; row += fromRow < toRow ? 1 : -1) {
        if (board[row][fromCol] != null) return false;
      }
    }
    return true;
  }

  bool _isValidKnightMove(int fromRow, int fromCol, int toRow, int toCol) {
    int rowDiff = (toRow - fromRow).abs();
    int colDiff = (toCol - fromCol).abs();
    return (rowDiff == 2 && colDiff == 1) || (rowDiff == 1 && colDiff == 2);
  }

  bool _isValidBishopMove(int fromRow, int fromCol, int toRow, int toCol) {
    if ((toRow - fromRow).abs() != (toCol - fromCol).abs()) return false;
    int rowDirection = toRow > fromRow ? 1 : -1;
    int colDirection = toCol > fromCol ? 1 : -1;
    for (int i = 1; i < (toRow - fromRow).abs(); i++) {
      if (board[fromRow + i * rowDirection][fromCol + i * colDirection] != null) {
        return false;
      }
    }
    return true;
  }

  bool _isValidQueenMove(int fromRow, int fromCol, int toRow, int toCol) {
    return _isValidRookMove(fromRow, fromCol, toRow, toCol) || _isValidBishopMove(fromRow, fromCol, toRow, toCol);
  }

  bool _isValidKingMove(int fromRow, int fromCol, int toRow, int toCol) {
    int rowDiff = (toRow - fromRow).abs();
    int colDiff = (toCol - fromCol).abs();
    return rowDiff <= 1 && colDiff <= 1;
  }

  void _startTimer() {
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      if (currentPlayer == Player.white) {
        playerTimes[Player.white] = playerTimes[Player.white]! - Duration(seconds: 1);
        if (playerTimes[Player.white]!.inSeconds <= 0) {
          gameOver = true;
          whiteTimer.stop();
          blackTimer.stop();
        }
      } else {
        playerTimes[Player.black] = playerTimes[Player.black]! - Duration(seconds: 1);
        if (playerTimes[Player.black]!.inSeconds <= 0) {
          gameOver = true;
          whiteTimer.stop();
          blackTimer.stop();
        }
      }
      notifyListeners();
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }
}
