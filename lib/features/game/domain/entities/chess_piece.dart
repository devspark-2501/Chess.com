class ChessPiece {
  final String type;  // 'pawn', 'knight', 'bishop', 'rook', 'queen', 'king'
  final String color; // 'white' or 'black'

  ChessPiece({required this.type, required this.color});

  String get assetPath => 'assets/images/pieces/$color/$type.png';
}