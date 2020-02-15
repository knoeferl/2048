import 'dart:math';

import 'package:flutter/rendering.dart';

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

  bool createTile() {
    var rand = Random();
    for (var i = 0; i < 30; i++) {
      int col = rand.nextInt(_board.length);
      int row = rand.nextInt(_board.length);
      if (_board[col][row].value == 0) {
        _board[col][row].value = random2or4(rand);
        return true;
      }
    }
    for (var row in _board) {
      for (var number in row) {
        if (number.value == 0) {
          number.value = random2or4(rand);
          return true;
        }
      }
    }
    return false;
  }
   List<Tile> flatList() {
    return this._board.expand((i) => i).toList();
  }

  moveTileRight(int col, int row, int value, Direction direction) {
    try {
      if (nextTile(col, row, direction).value == 0) {
        nextTile(col, row, direction).value = value;
        moveTileRight(col, row, value, direction);
      }
      if (moveTileRight(col, row, value, direction).value == value) {
        int newValue = value * 2;
        _board[col][row].value = 0;
        moveTileRight(col, row, value, direction).value = newValue;
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

  int random2or4(Random rand) => (rand.nextBool() ? 2 : 4);

  getLength() {
    return _board.length;
  }
}
