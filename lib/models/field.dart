import 'dart:math';

import './tile.dart';

enum Direction { left, right, top, bottom }

class Field {
  List<List<Tile>> _board;

  Field() {
    int row = -1;
    _board = [
      [0, 0, 0],
      [0, 2, 0],
      [0, 0, 0]
    ].map((list) {
      int col = -1;
      row++;
      return list.map((cell) {
        col++;
        return Tile(cell);
      }).toList();
    }).toList();
  }
List<Tile> getEmptyTiles(){
  List<Tile> ret = List();
   for (var row in _board) {
      for (var number in row) {
        if (number.value == 0) {
          ret.add(number);
        }
      }
    }
return ret;
}

  bool createTile() {
    var rand = Random();
    var emptyTiles = getEmptyTiles();
    if (emptyTiles.isEmpty) return false;
    emptyTiles.elementAt(rand.nextInt(emptyTiles.length)).value = random2or4();
    return true;
  }
   List<Tile> flatList() {
    return this._board.expand((i) => i).toList();
  }

  moveTile(int col, int row, int value, Direction direction) {
    try {
      if (nextTile(col, row, direction).value == 0) {
        nextTile(col, row, direction).value = value;
        moveTile(col, row, value, direction);
      }
      if (moveTile(col, row, value, direction).value == value) {
        int newValue = value * 2;
        _board[col][row].value = 0;
        moveTile(col, row, value, direction).value = newValue;
        if (newValue == 2048) {
          print("win");
        }
      }
    } catch (e) {
      return;
    }
  }

  Tile nextTile(int col, int row, Direction direction) {
    switch (direction) {
      case Direction.top:
        return _board[col + 1][row];
      case Direction.bottom:
        return _board[col - 1][row];
      case Direction.right:
        return _board[col][row + 1];
      case Direction.top:
        return _board[col][row - 1];
      default:
        return null;
    }
  }

  int random2or4() => (Random().nextBool() ? 2 : 4);

  getLength() {
    return _board.length;
  }
}
