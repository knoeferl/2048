class Tile {
  int value;
  int newValue;
  bool moveable;
  int col;
  int row;
  bool isNew = true;
  int positionVertical;
  int positionHorizontal;

  Tile({this.col , this.row, this.value}){
    newValue = value;
    moveable = true;
    positionVertical = 0;
    positionHorizontal = 0;
  }
  setMoveable(bool moveable){
    this.moveable = moveable;
  }
  @override
  String toString()
  {
    return "col: " + col.toString() + " row: "+ row.toString() + " value: " + value.toString();
  }

  bool isEmpty() {
    return value==0;
  }

  setValue(int value){
    this.value = value;
    newValue = value;
  }
}