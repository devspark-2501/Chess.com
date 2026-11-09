import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../domain/entities/chess_piece.dart';
import '../../domain/usecases/move_validator.dart';
import '../widgets/chess_board_widget.dart';
import '../widgets/captured_pieces.dart';

class GameScreen extends StatefulWidget {
  const GameScreen({super.key});

  @override
  State<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  late List<List<ChessPiece?>> board;
  List<ChessPiece> whiteCaptured = [];
  List<ChessPiece> blackCaptured = [];

  int? selectedRow;
  int? selectedCol;
  bool isWhiteTurn = true;

  @override
  void initState() {
    super.initState();
    _initializeBoard();
  }

  void _initializeBoard() {
    List<List<ChessPiece?>> newBoard = List.generate(
      8,
          (index) => List.filled(8, null),
    );

    List<String> pieceOrder = ['rook', 'knight', 'bishop', 'queen', 'king', 'bishop', 'knight', 'rook'];

    // Black pieces
    for (int col = 0; col < 8; col++) {
      newBoard[0][col] = ChessPiece(type: pieceOrder[col], color: 'black');
      newBoard[1][col] = ChessPiece(type: 'pawn', color: 'black');
    }

    // White pieces
    for (int col = 0; col < 8; col++) {
      newBoard[6][col] = ChessPiece(type: 'pawn', color: 'white');
      newBoard[7][col] = ChessPiece(type: pieceOrder[col], color: 'white');
    }

    board = newBoard;
  }

  void _handleSquareTap(int row, int col) {
    setState(() {
      ChessPiece? clickedPiece = board[row][col];

      if (selectedRow == null && selectedCol == null) {
        // First tap: Select a piece if it belongs to the current player
        if (clickedPiece != null) {
          if ((isWhiteTurn && clickedPiece.color == 'white') || (!isWhiteTurn && clickedPiece.color == 'black')) {
            selectedRow = row;
            selectedCol = col;
          }
        }
      } else {
        // If clicking another one of your own pieces, switch selection instead of trying to move there
        if (clickedPiece != null &&
            ((isWhiteTurn && clickedPiece.color == 'white') || (!isWhiteTurn && clickedPiece.color == 'black'))) {
          selectedRow = row;
          selectedCol = col;
          return;
        }

        // Second tap: Attempt to make the move
        if (ChessMoveValidator.isValidMove(board, selectedRow!, selectedCol!, row, col)) {
          if (clickedPiece != null) {
            if (clickedPiece.color == 'white') {
              blackCaptured.add(clickedPiece);
            } else {
              whiteCaptured.add(clickedPiece);
            }
          }

          // Execute move
          board[row][col] = board[selectedRow!][selectedCol!];
          board[selectedRow!][selectedCol!] = null;

          // Switch turn
          isWhiteTurn = !isWhiteTurn;
        }

        // Reset selection
        selectedRow = null;
        selectedCol = null;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundDark,
      appBar: AppBar(
        title: Text(isWhiteTurn ? "White's Turn (Player 1)" : "Black's Turn (Player 2)"),
        backgroundColor: AppColors.surfaceDark,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              setState(() {
                _initializeBoard();
                whiteCaptured.clear();
                blackCaptured.clear();
                isWhiteTurn = true;
                selectedRow = null;
                selectedCol = null;
              });
            },
            tooltip: 'Reset Game',
          )
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            _buildPlayerHeader('Player 2 (Black)', blackCaptured, !isWhiteTurn),
            const Spacer(),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12.0),
              child: ChessBoardWidget(
                board: board,
                selectedRow: selectedRow,
                selectedCol: selectedCol,
                onSquareTap: _handleSquareTap,
              ),
            ),
            const Spacer(),
            _buildPlayerHeader('Player 1 (White)', whiteCaptured, isWhiteTurn),
          ],
        ),
      ),
    );
  }

  Widget _buildPlayerHeader(String name, List<ChessPiece> captured, bool isActive) {
    return Container(
      padding: const EdgeInsets.all(12.0),
      color: isActive ? AppColors.surfaceDark.withOpacity(0.9) : AppColors.surfaceDark.withOpacity(0.4),
      child: Row(
        children: [
          CircleAvatar(
            backgroundColor: isActive ? AppColors.primaryGreen : Colors.grey,
            child: const Icon(Icons.person, color: Colors.white),
          ),
          const SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                name,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                  color: isActive ? Colors.white : Colors.grey,
                ),
              ),
              const SizedBox(height: 4),
              CapturedPiecesWidget(capturedPieces: captured),
            ],
          ),
        ],
      ),
    );
  }
}