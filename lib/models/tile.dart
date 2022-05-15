class Tile {
  late int value;
  late int newValue;
  late bool moveable;
  late int col;
  late int row;
  bool isNew = true;
  late int positionVertical;
  late int positionHorizontal;

  Tile({required this.col, required this.row, required this.value}) {
    newValue = value;
    moveable = true;
    positionVertical = 0;
    positionHorizontal = 0;
  }

  setMoveable(bool moveable) {
    this.moveable = moveable;
  }

  @override
  String toString() {
    return "col: $col row: $row value: $value";
  }

  bool isEmpty() {
    return value == 0;
  }

  setValue(int value) {
    this.value = value;
    newValue = value;
  }
}
