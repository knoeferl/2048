import 'dart:math';

import './tile.dart';

enum Direction { left, right, top, bottom }

class Field {

  List<List<Tile>> board;
  int score;
  Field({int size = 6}) 
  {
    board = Iterable.generate(size, (col) => Iterable.generate(size, (row) => Tile(col: col, row: row, value: 0)).toList()).toList();
    score = 0;
    createTile();
    createTile();
  }
  

  List<Tile> getEmptyTiles() {
    List<Tile> ret = List();
    for (var row in board) {
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
    return this.board.expand((i) => i).toList();
  }

  moveTiles(Direction direction) {
    switch (direction) {
        case Direction.top:
          for (int col = 0; col < board.length; ++col) {
            for (int row = 0; row < board.length; ++row) {
              moveTile(board[col][row], Direction.bottom);
            }
          }
          break;
        case Direction.bottom:
          for (int col = 0; col < board.length; ++col) {
            for (int row = 0; row < board.length; ++row) {
              moveTile(board[col][row], Direction.top);
            }
          }
          break;
        case Direction.right:
            for (int col = board.length-1; col >= 0; --col) {
              // for (int row = board.length; row < 0; --row) {
                moveTile(board[col][board.length-1], Direction.left);
              // }
            }
            break;
        case Direction.left:
        for (int col = 0; col < board.length; ++col) {
          // for (int row = 0; row < board.length; ++row) {
            moveTile(board[col][0], Direction.right);
          // }
        }
        break;
        default:
          return;
      }
  }

  moveTile(Tile tile, Direction direction) {
    try {
      nextTile(tile, direction);
    } catch (e){
      return;
    }

    try 
    {
      if (nextTile(tile, direction).value == 0 && tile.value == 0) {
        moveTile(nextTile(tile, direction), direction);
        return;
      }
      if (nextTile(tile, direction).value != 0 && tile.value == 0) {
        tile.value = nextTile(tile, direction).value;
        nextTile(tile, direction).value = 0;
        moveTile(nextTile(tile, direction), direction);
        moveTile(nextTile(tile, reverseDircetion(direction)), direction);
        return;
      }
      if (nextTile(tile, direction).value == tile.value && tile.value != 0) {
        int newValue = tile.value * 2;
        score += newValue;
        tile.value = newValue;
        nextTile(tile, direction).value = 0;
        tile.setMoveable(false);
        moveTile(nextTile(tile, direction), direction);
        if (newValue == 2048) {}
        return;
      }     
      moveTile(nextTile(tile, direction), direction);
    } 
    catch (e) 
    {

    }
  }

  Direction reverseDircetion(Direction direction){
    switch (direction) {
        case Direction.top:
          return Direction.bottom;
        case Direction.bottom:
          return Direction.top;
        case Direction.right:
          return Direction.left;
        case Direction.left:
          return Direction.right;
        default:
          return null;
  }
  }

  Tile nextTile(Tile tile, Direction direction) {
      switch (direction) {
        case Direction.top:
          if (0 > tile.col) throw Exception();
          return board[tile.col + 1][tile.row];
        case Direction.bottom:
          if (board.length - 1 < tile.col) throw Exception();
          return board[tile.col - 1][tile.row];
        case Direction.right:
          if (board.length - 1 < tile.row) throw Exception();
          return board[tile.col][tile.row + 1];
        case Direction.left:
          if (0 > tile.row) throw Exception();
          return board[tile.col][tile.row - 1];
        default:
          return null;
      }
  }

  int random2or4() => (Random().nextBool() ? 2 : 4);

  int getLength() {
    return board.length;
  }
}
