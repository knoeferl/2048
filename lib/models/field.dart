import 'dart:math';

import './tile.dart';

enum Direction { left, right, top, bottom }

class Field {
  List<List<Tile>> board;
  List<List<int>> lastBoard;
  int size;
  int score;
  int oldScore;
  bool notMoved = false;
  bool gameWon = false;
  Field({this.size = 4}) {
    board = Iterable.generate(
        size,
        (col) =>
            Iterable.generate(size, (row) => Tile(col: col, row: row, value: 0))
                .toList()).toList();
    gameWon = false;
    score = 0;
    oldScore = score;
    createTile();
    createTile();
    saveBoard();
    notMoved = true;
  }

  void saveBoard() {
    lastBoard = Iterable.generate(
        size,
        (col) => Iterable.generate(size,
                (row) => board[col][row].value)
            .toList()).toList();
            print(lastBoard);
    oldScore = score;
    notMoved = true;
  }
  void setBoard() {
    for (int col =0; col < board.length; ++col){
      for (int row = 0; row < board.length; ++row) {
        board[col][row].value = lastBoard[col][row];
      }
    }
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
    if (notMoved) return false;
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
          for (int row = 0; row < board.length; ++row) {
            moveTile(board[board.length-1][row], Direction.bottom);
          }
        break;
      case Direction.bottom:
          for (int row = 0; row < board.length; ++row) {
            moveTile(board[0][row], Direction.top);
          }
        break;
      case Direction.right:
        for (int col = board.length - 1; col >= 0; --col) {
          moveTile(board[col][board.length - 1], Direction.left);
        }
        break;
      case Direction.left:
        for (int col = 0; col < board.length; ++col) {
          moveTile(board[col][0], Direction.right);
        }
        break;
      default:
        return;
    }
  }

  moveTile(Tile tile, Direction direction) {
    try {
      Tile nextTileN = nextTile(tile, direction);
      if (nextTileN.value == 0 && tile.value == 0) {
        moveTile(nextTileN, direction);
        return;
      }
      if (nextTileN.value != 0 && tile.value == 0) {
        tile.isNew = false;
        tile.value = nextTileN.value;
        nextTileN.value = 0;
        nextTileN.isNew = true;
        moveTile(nextTileN, direction);
        moveTile(nextTile(tile, reverseDircetion(direction)), direction);
        notMoved = false;
        return;
      }
      if (nextTileN.value == tile.value && tile.value != 0) {
        tile.isNew = false;
        int newValue = tile.value * 2;
        notMoved = false;
        score += newValue;
        tile.value = newValue;
        nextTileN.value = 0;
        nextTileN.isNew = true;
        moveTile(nextTileN, direction);
        if (newValue == 2048) {
          gameWon = true;
        }
        return;
      }
      moveTile(nextTileN, direction);
    } catch (e) {}
  }

  Direction reverseDircetion(Direction direction) {
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
