import 'package:flutter/material.dart';
import '../../domain/entities/chess_piece.dart';

class CapturedPiecesWidget extends StatelessWidget {
  final List<ChessPiece> capturedPieces;

  const CapturedPiecesWidget({
    super.key,
    required this.capturedPieces,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 30,
      child: Row(
        children: capturedPieces.map((piece) {
          return Padding(
            padding: const EdgeInsets.only(right: 4.0),
            child: Image.asset(
              piece.assetPath,
              width: 24,
              height: 24,
            ),
          );
        }).toList(),
      ),
    );
  }
}