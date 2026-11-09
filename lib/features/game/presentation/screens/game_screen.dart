import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../domain/entities/chess_piece.dart';
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
      if (selectedRow == null && selectedCol == null) {
        if (board[row][col] != null) {
          selectedRow = row;
          selectedCol = col;
        }
      } else {
        ChessPiece? targetPiece = board[row][col];
        if (targetPiece != null) {
          if (targetPiece.color == 'white') {
            blackCaptured.add(targetPiece);
          } else {
            whiteCaptured.add(targetPiece);
          }
        }

        board[row][col] = board[selectedRow!][selectedCol!];
        board[selectedRow!][selectedCol!] = null;

        selectedRow = null;
        selectedCol = null;
        isWhiteTurn = !isWhiteTurn;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundDark,
      appBar: AppBar(
        title: const Text('1v1 Match'),
        backgroundColor: AppColors.surfaceDark,
      ),
      body: SafeArea(
        child: Column(
          children: [
            _buildPlayerHeader('Player 2 (Black)', blackCaptured),
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
            _buildPlayerHeader('Player 1 (White)', whiteCaptured),
          ],
        ),
      ),
    );
  }

  Widget _buildPlayerHeader(String name, List<ChessPiece> captured) {
    return Container(
      padding: const EdgeInsets.all(12.0),
      color: AppColors.surfaceDark,
      child: Row(
        children: [
          const CircleAvatar(
            backgroundColor: AppColors.primaryGreen,
            child: Icon(Icons.person, color: Colors.white),
          ),
          const SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start, // Fixed typo here
            children: [
              Text(
                name,
                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
              CapturedPiecesWidget(capturedPieces: captured),
            ],
          ),
        ],
      ),
    );
  }
}