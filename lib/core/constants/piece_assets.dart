class PieceAssets {
  static String getImagePath(String color, String piece) {
    // color: 'white' or 'black'
    // piece: 'pawn', 'knight', 'bishop', 'rook', 'queen', 'king'
    return 'assets/images/pieces/$color/$piece.png';
  }
}