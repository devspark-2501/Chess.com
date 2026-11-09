import '../entities/chess_piece.dart';

class ChessMoveValidator {
  static bool isValidMove(
      List<List<ChessPiece?>> board,
      int startRow,
      int startCol,
      int endRow,
      int endCol,
      ) {
    ChessPiece? piece = board[startRow][startCol];
    if (piece == null) return false;

    // Cannot capture your own piece
    ChessPiece? targetPiece = board[endRow][endCol];
    if (targetPiece != null && targetPiece.color == piece.color) {
      return false;
    }

    switch (piece.type) {
      case 'pawn':
        return _isValidPawnMove(board, startRow, startCol, endRow, endCol, piece.color);
      case 'rook':
        return _isValidRookMove(board, startRow, startCol, endRow, endCol);
      case 'knight':
        return _isValidKnightMove(startRow, startCol, endRow, endCol);
      case 'bishop':
        return _isValidBishopMove(board, startRow, startCol, endRow, endCol);
      case 'queen':
        return _isValidRookMove(board, startRow, startCol, endRow, endCol) ||
            _isValidBishopMove(board, startRow, startCol, endRow, endCol);
      case 'king':
        return _isValidKingMove(startRow, startCol, endRow, endCol);
      default:
        return false;
    }
  }

  static bool _isValidPawnMove(
      List<List<ChessPiece?>> board,
      int startRow,
      int startCol,
      int endRow,
      int endCol,
      String color,
      ) {
    int direction = (color == 'white') ? -1 : 1;
    int startRank = (color == 'white') ? 6 : 1;

    // Move forward 1 square
    if (startCol == endCol && endRow == startRow + direction && board[endRow][endCol] == null) {
      return true;
    }

    // Move forward 2 squares from starting rank
    if (startCol == endCol && startRow == startRank && endRow == startRow + (direction * 2)) {
      if (board[startRow + direction][startCol] == null && board[endRow][endCol] == null) {
        return true;
      }
    }

    // Diagonal capture
    if ((endCol == startCol - 1 || endCol == startCol + 1) && endRow == startRow + direction) {
      if (board[endRow][endCol] != null) {
        return true;
      }
    }

    return false;
  }

  static bool _isValidRookMove(List<List<ChessPiece?>> board, int startRow, int startCol, int endRow, int endCol) {
    if (startRow != endRow && startCol != endCol) return false;

    int rowStep = startRow == endRow ? 0 : (endRow > startRow ? 1 : -1);
    int colStep = startCol == endCol ? 0 : (endCol > startCol ? 1 : -1);

    int currRow = startRow + rowStep;
    int currCol = startCol + colStep;

    while (currRow != endRow || currCol != endCol) {
      if (board[currRow][currCol] != null) return false;
      currRow += rowStep;
      currCol += colStep;
    }

    return true;
  }

  static bool _isValidKnightMove(int startRow, int startCol, int endRow, int endCol) {
    int rowDiff = (endRow - startRow).abs();
    int colDiff = (endCol - startCol).abs();
    return (rowDiff == 2 && colDiff == 1) || (rowDiff == 1 && colDiff == 2);
  }

  static bool _isValidBishopMove(List<List<ChessPiece?>> board, int startRow, int startCol, int endRow, int endCol) {
    if ((endRow - startRow).abs() != (endCol - startCol).abs()) return false;

    int rowStep = endRow > startRow ? 1 : -1;
    int colStep = endCol > startCol ? 1 : -1;

    int currRow = startRow + rowStep;
    int currCol = startCol + colStep;

    while (currRow != endRow && currCol != endCol) {
      if (board[currRow][currCol] != null) return false;
      currRow += rowStep;
      currCol += colStep;
    }

    return true;
  }

  static bool _isValidKingMove(int startRow, int startCol, int endRow, int endCol) {
    int rowDiff = (endRow - startRow).abs();
    int colDiff = (endCol - startCol).abs();
    return rowDiff <= 1 && colDiff <= 1 && (rowDiff + colDiff > 0);
  }
}