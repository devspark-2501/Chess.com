import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../domain/entities/chess_piece.dart';

class ChessBoardWidget extends StatelessWidget {
  final List<List<ChessPiece?>> board;
  final Function(int row, int col)? onSquareTap;
  final int? selectedRow;
  final int? selectedCol;

  const ChessBoardWidget({
    super.key,
    required this.board,
    this.onSquareTap,
    this.selectedRow,
    this.selectedCol,
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

            // Square coloring with selection highlight
            Color squareColor = isSelected
                ? AppColors.primaryGreen.withOpacity(0.8)
                : (isLightSquare ? AppColors.lightSquare : AppColors.darkSquare);

            ChessPiece? piece = board[row][col];

            return GestureDetector(
              onTap: () => onSquareTap?.call(row, col),
              child: Container(
                color: squareColor,
                child: Center(
                  child: piece != null
                      ? Padding(
                    padding: const EdgeInsets.all(4.0),
                    child: Image.asset(piece.assetPath),
                  )
                      : null,
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}