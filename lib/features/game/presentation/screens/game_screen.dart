import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../domain/entities/chess_piece.dart';
import '../../domain/usecases/move_validator.dart';
import '../widgets/chess_board_widget.dart';
import '../widgets/captured_pieces.dart';
import '../widgets/game_over_dialog.dart';

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
  List<List<int>> currentValidMoves = [];
  bool isWhiteTurn = true;
  String? gameOverMessage;

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

    for (int col = 0; col < 8; col++) {
      newBoard[0][col] = ChessPiece(type: pieceOrder[col], color: 'black');
      newBoard[1][col] = ChessPiece(type: 'pawn', color: 'black');
    }

    for (int col = 0; col < 8; col++) {
      newBoard[6][col] = ChessPiece(type: 'pawn', color: 'white');
      newBoard[7][col] = ChessPiece(type: pieceOrder[col], color: 'white');
    }

    setState(() {
      board = newBoard;
      whiteCaptured.clear();
      blackCaptured.clear();
      isWhiteTurn = true;
      selectedRow = null;
      selectedCol = null;
      currentValidMoves.clear();
      gameOverMessage = null;
    });
  }

  void _handleSquareTap(int row, int col) {
    if (gameOverMessage != null) return;

    setState(() {
      ChessPiece? clickedPiece = board[row][col];

      if (selectedRow == null && selectedCol == null) {
        if (clickedPiece != null) {
          if ((isWhiteTurn && clickedPiece.color == 'white') || (!isWhiteTurn && clickedPiece.color == 'black')) {
            selectedRow = row;
            selectedCol = col;
            currentValidMoves = ChessMoveValidator.getValidMoves(board, row, col);
          }
        }
      } else {
        if (clickedPiece != null &&
            ((isWhiteTurn && clickedPiece.color == 'white') || (!isWhiteTurn && clickedPiece.color == 'black'))) {
          selectedRow = row;
          selectedCol = col;
          currentValidMoves = ChessMoveValidator.getValidMoves(board, row, col);
          return;
        }

        if (ChessMoveValidator.isValidMove(board, selectedRow!, selectedCol!, row, col)) {
          ChessPiece movingPiece = board[selectedRow!][selectedCol!]!;

          if (clickedPiece != null) {
            if (clickedPiece.type == 'king') {
              gameOverMessage = "${movingPiece.color.toUpperCase()} Wins by Checkmate!";
            }
            if (clickedPiece.color == 'white') {
              blackCaptured.add(clickedPiece);
            } else {
              whiteCaptured.add(clickedPiece);
            }
          }

          board[row][col] = movingPiece;
          board[selectedRow!][selectedCol!] = null;

          if (movingPiece.type == 'pawn' && (row == 0 || row == 7)) {
            _showPromotionDialog(row, col, movingPiece.color);
          }

          isWhiteTurn = !isWhiteTurn;
        }

        selectedRow = null;
        selectedCol = null;
        currentValidMoves.clear();
      }
    });
  }

  void _showPromotionDialog(int row, int col, String color) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return AlertDialog(
            backgroundColor: AppColors.surfaceDark,
            title: const Text('Pawn Promotion', style: TextStyle(color: Colors.white)),
            content: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: ['queen', 'rook', 'bishop', 'knight'].map((pieceType) {
                return GestureDetector(
                  onTap: () {
                    setState(() {
                      board[row][col] = ChessPiece(type: pieceType, color: color);
                    });
                    Navigator.of(context).pop();
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Image.asset(
                      'assets/images/pieces/$color/$pieceType.png',
                      width: 40,
                      height: 40,
                    ),
                  ),
                );
              }).toList(),
            ),
          );
        },
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundDark,
      appBar: AppBar(
        title: Text(isWhiteTurn ? "White's Turn" : "Black's Turn"),
        backgroundColor: AppColors.surfaceDark,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _initializeBoard,
            tooltip: 'Reset Game',
          )
        ],
      ),
      body: Stack(
        children: [
          SafeArea(
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
                    validMoves: currentValidMoves,
                    onSquareTap: _handleSquareTap,
                  ),
                ),
                const Spacer(),
                _buildPlayerHeader('Player 1 (White)', whiteCaptured, isWhiteTurn),
              ],
            ),
          ),
          // Blur checkmate overlay screen takes over when game ends
          if (gameOverMessage != null)
            GameOverDialog(
              message: gameOverMessage!,
              onRematch: _initializeBoard,
            ),
        ],
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