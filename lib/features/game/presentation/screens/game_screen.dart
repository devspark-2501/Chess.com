import 'package:flutter/material.dart';
import '../../../../core/constants/piece_assets.dart';

class GameScreen extends StatelessWidget {
  const GameScreen({super.key});

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

                  // Chess.com board colors
                  Color squareColor = isLightSquare
                      ? const Color(0xFFEBECD0) // Light square
                      : const Color(0xFF739552); // Dark square

                  // Example: Place a white rook at the bottom-right corner (row 7, col 7)
                  Widget? pieceWidget;
                  if (row == 7 && col == 7) {
                    pieceWidget = Image.asset(
                      PieceAssets.getImagePath('white', 'rook'),
                    );
                  }

                  return Container(
                    color: squareColor,
                    child: Center(
                      child: pieceWidget,
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