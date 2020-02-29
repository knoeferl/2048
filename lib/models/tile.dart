class Tile {
  int value;
  bool moveable;
  int col;
  int row;

  Tile({int col , int row, int value}){
    this.col = col;
    this.row = row;
    this.value = value;
    this.moveable = true;
  }
  setMoveable(bool moveable){
    this.moveable = moveable;
  }
  @override
  String toString()
  {
    return "col: " + col.toString() + " row: "+ row.toString() + " value: " + value.toString();
  }
}