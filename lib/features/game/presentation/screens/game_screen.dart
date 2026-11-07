import 'package:flutter/material.dart';
import '../../../../core/constants/piece_assets.dart';
import '../../domain/entities/chess_piece.dart';

class GameScreen extends StatefulWidget {
  const GameScreen({super.key});

  @override
  State<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  // 8x8 grid representing the board. Null means empty square.
  late List<List<ChessPiece?>> board;

  @override
  void initState() {
    super.initState();
    _initializeBoard();
  }

  void _initializeBoard() {
    // Create empty 8x8 board
    List<List<ChessPiece?>> newBoard = List.generate(
      8,
          (index) => List.filled(8, null),
    );

    // --- Setup Black Pieces (Rows 0 and 1) ---
    // Back row
    List<String> pieceOrder = ['rook', 'knight', 'bishop', 'queen', 'king', 'bishop', 'knight', 'rook'];
    for (int col = 0; col < 8; col++) {
      newBoard[0][col] = ChessPiece(type: pieceOrder[col], color: 'black');
      newBoard[1][col] = ChessPiece(type: 'pawn', color: 'black');
    }

    // --- Setup White Pieces (Rows 6 and 7) ---
    for (int col = 0; col < 8; col++) {
      newBoard[6][col] = ChessPiece(type: 'pawn', color: 'white');
      newBoard[7][col] = ChessPiece(type: pieceOrder[col], color: 'white');
    }

    board = newBoard;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF161512),
      appBar: AppBar(
        title: const Text('1v1 Match'),
        backgroundColor: const Color(0xFF262421),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: AspectRatio(
            aspectRatio: 1.0, // Keeps the chessboard perfectly square
            child: Container(
              decoration: BoxDecoration(
                border: Border.all(color: const Color(0xFF262421), width: 4),
              ),
              child: GridView.builder(
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 8,
                ),
                itemCount: 64,
                itemBuilder: (context, index) {
                  int row = index ~/ 8;
                  int col = index % 8;
                  bool isLightSquare = (row + col) % 2 == 0;

                  Color squareColor = isLightSquare
                      ? const Color(0xFFEBECD0) // Light square
                      : const Color(0xFF739552); // Dark square

                  ChessPiece? piece = board[row][col];

                  return Container(
                    color: squareColor,
                    child: Center(
                      child: piece != null
                          ? Padding(
                        padding: const EdgeInsets.all(4.0),
                        child: Image.asset(piece.assetPath),
                      )
                          : null,
                    ),
                  );
                },
              ),
            ),
          ),
        ),
      ),
    );
  }
}