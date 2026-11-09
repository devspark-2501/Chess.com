import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../domain/entities/chess_piece.dart';

class ChessBoardWidget extends StatelessWidget {
  final List<List<ChessPiece?>> board;
  final Function(int row, int col)? onSquareTap;
  final int? selectedRow;
  final int? selectedCol;
  final List<List<int>> validMoves;

  const ChessBoardWidget({
    super.key,
    required this.board,
    this.onSquareTap,
    this.selectedRow,
    this.selectedCol,
    required this.validMoves,
  });

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 1.0,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(4),
          border: Border.all(color: AppColors.surfaceDark, width: 4),
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
            bool isSelected = selectedRow == row && selectedCol == col;

            // Check if this square is a valid target move
            bool isValidTarget = validMoves.any((m) => m[0] == row && m[1] == col);

            Color squareColor = isSelected
                ? AppColors.primaryGreen.withOpacity(0.8)
                : (isLightSquare ? AppColors.lightSquare : AppColors.darkSquare);

            ChessPiece? piece = board[row][col];

            return GestureDetector(
              onTap: () => onSquareTap?.call(row, col),
              child: Container(
                color: squareColor,
                child: Stack(
                  children: [
                    Center(
                      child: piece != null
                          ? Padding(
                        padding: const EdgeInsets.all(4.0),
                        child: Image.asset(piece.assetPath),
                      )
                          : null,
                    ),
                    // Show a highlight dot or ring on valid move destination squares
                    if (isValidTarget)
                      Center(
                        child: Container(
                          width: piece == null ? 16 : 48,
                          height: piece == null ? 16 : 48,
                          decoration: BoxDecoration(
                            color: piece == null
                                ? Colors.black.withOpacity(0.3)
                                : Colors.transparent,
                            shape: piece == null ? BoxShape.circle : BoxShape.rectangle,
                            border: piece != null
                                ? Border.all(color: Colors.redAccent, width: 4)
                                : null,
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}