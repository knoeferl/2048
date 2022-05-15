import 'dart:math';

import './tile.dart';

enum Direction { left, right, top, bottom }

class Field {
  late List<List<Tile>> board;
  late List<List<int>> lastBoard;
  late int size;
  late int score;
  late int oldScore;
  late bool notMoved;
  late bool gameWon;
  late bool gameLost;
  late bool playAfterWon;
  final rand = Random();

  Field({this.size = 4}) {
    board = Iterable.generate(
        size,
        (col) =>
            Iterable.generate(size, (row) => Tile(col: col, row: row, value: 0))
                .toList()).toList();
    gameWon = false;
    score = 0;
    oldScore = score;
    gameWon = false;
    gameLost = false;
    playAfterWon = false;
    notMoved = false;
    createTile();
    createTile();
    saveBoard();
    notMoved = true;
  }

  void saveBoard() {
    lastBoard = Iterable.generate(
        size,
        (col) => Iterable.generate(size, (row) => board[col][row].newValue)
            .toList()).toList();
    oldScore = score;
    notMoved = true;
  }

  void setBoard() {
    for (int col = 0; col < board.length; ++col) {
      for (int row = 0; row < board.length; ++row) {
        board[col][row].value = lastBoard[col][row];
        board[col][row].newValue = lastBoard[col][row];
      }
    }
    score = oldScore;
  }

  List<Tile> getEmptyTiles() {
    List<Tile> ret = [];
    for (var row in board) {
      for (var col in row) {
        if (col.newValue == 0) {
          ret.add(col);
        }
      }
    }
    return ret;
  }

  bool createTile() {
    if (notMoved) return false;
    var emptyTiles = getEmptyTiles();
    if (emptyTiles.isEmpty) return false;
    var tile = emptyTiles.elementAt(rand.nextInt(emptyTiles.length));
    tile.setValue(random2or4());
    return true;
  }

  List<Tile> flatList() {
    return board.expand((i) => i).toList();
  }

  moveTiles(Direction direction) {
    for (int col = 0; col < board.length; ++col) {
      for (int row = 0; row < board.length; ++row) {
        board[col][row].moveable = true;
      }
    }
    switch (direction) {
      case Direction.top:
        for (int row = 0; row < board.length; ++row) {
          moveTile(board[board.length - 1][row], Direction.bottom);
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
      Tile? nextTileN = nextTile(tile, direction);
      if (nextTileN == null) return;
      if (nextTileN.newValue == 0 && tile.newValue == 0) {
        moveTile(nextTileN, direction);
        return;
      }
      if (nextTileN.newValue != 0 && tile.newValue == 0) {
        tile.isNew = false;
        tile.newValue = nextTileN.newValue;
        nextTileN.newValue = 0;
        nextTileN.isNew = true;
        changePosition(nextTileN, direction: direction);
        moveTile(nextTileN, direction);
        Tile? nextTile2 = nextTile(tile, reverseDirection(direction));
        if (nextTile2 != null) {
          moveTile(nextTile2, direction);
        }
        notMoved = false;
        return;
      }
      if (nextTileN.newValue == tile.newValue &&
          tile.newValue != 0 &&
          tile.moveable) {
        tile.isNew = true;
        int newValue = tile.newValue * 2;
        score += newValue;
        tile.newValue = newValue;
        tile.moveable = false;
        nextTileN.newValue = 0;
        nextTileN.isNew = true;
        changePosition(nextTileN, direction: direction);
        moveTile(nextTileN, direction);
        if (newValue == 2048) {
          gameWon = true;
        }
        notMoved = false;
        return;
      }
      moveTile(nextTileN, direction);
    } catch (e) {
      return;
    }
  }

  changePosition(Tile tile, {required Direction direction}) {
    switch (direction) {
      case Direction.top:
        tile.positionVertical = -1;
        break;
      case Direction.bottom:
        tile.positionVertical = 1;
        break;
      case Direction.right:
        tile.positionHorizontal = -1;
        break;
      case Direction.left:
        tile.positionHorizontal = 1;
        break;
      default:
        tile.positionHorizontal = 0;
        tile.positionVertical = 0;
        break;
    }
  }

  Direction reverseDirection(Direction direction) {
    switch (direction) {
      case Direction.top:
        return Direction.bottom;
      case Direction.bottom:
        return Direction.top;
      case Direction.right:
        return Direction.left;
      case Direction.left:
        return Direction.right;
    }
  }

  Tile? nextTile(Tile tile, Direction direction) {
    switch (direction) {
      case Direction.top:
        if (0 > tile.col) return null;
        return board[tile.col + 1][tile.row];
      case Direction.bottom:
        if (board.length - 1 < tile.col) return null;
        return board[tile.col - 1][tile.row];
      case Direction.right:
        if (board.length - 1 < tile.row) return null;
        return board[tile.col][tile.row + 1];
      case Direction.left:
        if (0 > tile.row) return null;
        return board[tile.col][tile.row - 1];
    }
  }

  int random2or4() => (Random().nextBool() ? 2 : 4);

  int getLength() {
    return board.length;
  }

  bool isGameLost() {
    // if (getEmptyTiles().isEmpty) return true;
    for (int col = 0; col < board.length; ++col) {
      for (int row = 0; row < board.length; ++row) {
        Tile? nextTileT = nextTile(board[col][row], Direction.top);
        if (nextTileT != null && board[col][row].value == nextTileT.value)
          return false;
        var nextTileB = nextTile(board[col][row], Direction.bottom);
        if (nextTileB != null && board[col][row].value == nextTileB.value)
          return false;
        var nextTileLeft = nextTile(board[col][row], Direction.left);
        if (nextTileLeft != null && board[col][row].value == nextTileLeft.value)
          return false;
        var nextTileRight = nextTile(board[col][row], Direction.right);
        if (nextTileRight != null &&
            board[col][row].value == nextTileRight.value) return false;
      }
    }
    return true;
  }
}
