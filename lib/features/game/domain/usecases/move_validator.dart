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

    ChessPiece? targetPiece = board[endRow][endCol];
    if (targetPiece != null && targetPiece.color == piece.color) {
      return false;
    }

    // Basic geometric check per piece type
    bool basicValid = false;
    switch (piece.type) {
      case 'pawn':
        basicValid = _isValidPawnMove(board, startRow, startCol, endRow, endCol, piece.color);
        break;
      case 'rook':
        basicValid = _isValidRookMove(board, startRow, startCol, endRow, endCol);
        break;
      case 'knight':
        basicValid = _isValidKnightMove(startRow, startCol, endRow, endCol);
        break;
      case 'bishop':
        basicValid = _isValidBishopMove(board, startRow, startCol, endRow, endCol);
        break;
      case 'queen':
        basicValid = _isValidRookMove(board, startRow, startCol, endRow, endCol) ||
            _isValidBishopMove(board, startRow, startCol, endRow, endCol);
        break;
      case 'king':
        basicValid = _isValidKingMove(startRow, startCol, endRow, endCol);
        break;
    }

    if (!basicValid) return false;

    // Simulation check: Ensure the move does not leave your own king in check
    return !_resultsInCheck(board, startRow, startCol, endRow, endCol, piece.color);
  }

  static List<List<int>> getValidMoves(List<List<ChessPiece?>> board, int startRow, int startCol) {
    List<List<int>> validMoves = [];
    for (int r = 0; r < 8; r++) {
      for (int c = 0; c < 8; c++) {
        if (isValidMove(board, startRow, startCol, r, c)) {
          validMoves.add([r, c]);
        }
      }
    }
    return validMoves;
  }

  // Check if a specific player's king is currently under attack
  static bool isKingInCheck(List<List<ChessPiece?>> board, String color) {
    int? kingRow;
    int? kingCol;

    // Find King coordinates
    for (int r = 0; r < 8; r++) {
      for (int c = 0; c < 8; c++) {
        ChessPiece? p = board[r][c];
        if (p != null && p.type == 'king' && p.color == color) {
          kingRow = r;
          kingCol = c;
          break;
        }
      }
      if (kingRow != null) break;
    }

    if (kingRow == null || kingCol == null) return false;

    // Check if any opponent piece can attack the king's square
    String opponentColor = (color == 'white') ? 'black' : 'white';
    for (int r = 0; r < 8; r++) {
      for (int c = 0; c < 8; c++) {
        ChessPiece? p = board[r][c];
        if (p != null && p.color == opponentColor) {
          if (_rawPieceCanAttack(board, r, c, kingRow, kingCol)) {
            return true;
          }
        }
      }
    }
    return false;
  }

  static bool _resultsInCheck(List<List<ChessPiece?>> board, int startRow, int startCol, int endRow, int endCol, String color) {
    // Clone board state temporarily
    List<List<ChessPiece?>> tempBoard = List.generate(
      8,
          (r) => List.from(board[r]),
    );

    tempBoard[endRow][endCol] = tempBoard[startRow][startCol];
    tempBoard[startRow][startCol] = null;

    return isKingInCheck(tempBoard, color);
  }

  static bool _rawPieceCanAttack(List<List<ChessPiece?>> board, int startRow, int startCol, int endRow, int endCol) {
    ChessPiece? piece = board[startRow][startCol];
    if (piece == null) return false;

    switch (piece.type) {
      case 'pawn':
        int direction = (piece.color == 'white') ? -1 : 1;
        return (endCol == startCol - 1 || endCol == startCol + 1) && endRow == startRow + direction;
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

  static bool _isValidPawnMove(List<List<ChessPiece?>> board, int startRow, int startCol, int endRow, int endCol, String color) {
    int direction = (color == 'white') ? -1 : 1;
    int startRank = (color == 'white') ? 6 : 1;

    if (startCol == endCol && endRow == startRow + direction && board[endRow][endCol] == null) return true;
    if (startCol == endCol && startRow == startRank && endRow == startRow + (direction * 2)) {
      if (board[startRow + direction][startCol] == null && board[endRow][endCol] == null) return true;
    }
    if ((endCol == startCol - 1 || endCol == startCol + 1) && endRow == startRow + direction) {
      if (board[endRow][endCol] != null) return true;
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