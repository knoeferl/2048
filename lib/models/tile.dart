class Tile {
  int value;
  bool moveable;
  int col;
  int row;

  Tile({this.col , this.row, this.value}){
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