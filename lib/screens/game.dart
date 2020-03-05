import 'package:flutter/material.dart';
import '../models/field.dart';
import '../widgets/Tile.dart';
import '../widgets/listdrawer.dart';

class Game extends StatefulWidget {
  Game({Key key}) : super(key: key);

  @override
  _GameState createState() => _GameState();
}

class _GameState extends State<Game> {
  bool gameOver;
  bool _isMoving;
  Field buttonsList;
  double totalwidth= 400;
  GlobalKey _fieldkey = GlobalKey();

  @override
  void initState() {
    super.initState();
    gameOver = false;
    _isMoving = false;
    buttonsList = Field();
    WidgetsBinding.instance.addPostFrameCallback((_) => getFieldSize());
  }

  getFieldSize() {
    RenderBox fieldsize = _fieldkey.currentContext.findRenderObject();
    totalwidth = fieldsize.size.width;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: ListDrawer(newGame: newGame),
      appBar: new AppBar(
          title: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text("2048"),
        ],
      )),
      body: Container(
        decoration: BoxDecoration(
          color: Colors.orange[50],
        ),
        child: new Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Container(
                margin: const EdgeInsets.all(8.0),
                height: 100,
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.max,
                  children: <Widget>[
                    Expanded(
                      flex: 1,
                      child: Container(
                        margin: const EdgeInsets.all(8.0),
                        padding: const EdgeInsets.all(8.0),
                        decoration: BoxDecoration(color: Colors.orange[100]),
                        child: FittedBox(
                          child: Column(
                            children: <Widget>[
                              Text(
                                "score",
                                textScaleFactor: 7,
                              ),
                              Text(
                                buttonsList.score.toString(),
                                textScaleFactor: 10,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      child: FittedBox(
                        fit: BoxFit.fitWidth,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: FlatButton(
                              color: Colors.orange[100],
                              onPressed: () => redo(),
                              child: Icon(Icons.redo)),
                        ),
                      ),
                    )
                  ],
                ),
              ),
              AspectRatio(
                aspectRatio: 1,
                child: Padding(
                  padding: EdgeInsets.all(5),
                  child: GestureDetector(
                    onVerticalDragUpdate: (detail) {
                      if (detail.delta.distance == 0 || _isMoving) {
                        return;
                      }
                      _isMoving = true;
                      if (detail.delta.direction > 0) {
                        setState(() {
                          moveTiles(Direction.top);
                        });
                      } else {
                        setState(() {
                          moveTiles(Direction.bottom);
                        });
                      }
                    },
                    onVerticalDragEnd: (d) {
                      _isMoving = false;
                    },
                    onVerticalDragCancel: () {
                      _isMoving = false;
                    },
                    onHorizontalDragUpdate: (d) {
                      if (d.delta.distance == 0 || _isMoving) {
                        return;
                      }
                      _isMoving = true;
                      if (d.delta.direction > 0) {
                        setState(() {
                          moveTiles(Direction.left);
                        });
                      } else {
                        setState(() {
                          moveTiles(Direction.right);
                        });
                      }
                    },
                    onHorizontalDragEnd: (d) {
                      _isMoving = false;
                    },
                    onHorizontalDragCancel: () {
                      _isMoving = false;
                    },
                    child: Container(
                      key: _fieldkey,
                      decoration: BoxDecoration(color: Colors.grey[500]),
                      child: Stack(
                          children: Iterable.generate(
                              buttonsList.flatList().length, (tileNum) {
                        var tileWidth = totalwidth / buttonsList.getLength();
                        return AnimatedPositioned(
                          key: Key("tile"+tileNum.toString()),
                            left: (tileNum % buttonsList.getLength() * tileWidth)
                                .toDouble(),
                            top: ((tileNum / buttonsList.getLength())
                                        .toDouble()
                                        .floor() *
                                    tileWidth)
                                .toDouble(),
                            child: TileBox(
                              context: context,
                              buttonsList: buttonsList,
                              tileNum: tileNum,
                              tileWidth: tileWidth,
                              tile: buttonsList.flatList()[tileNum],
                            ), duration: Duration(milliseconds: 300),);
                      }).toList()),
                    ),
                  ),
                ),
              ),
            ]),
      ),
    );
  }

  void createTile() {
    setState(() {
      buttonsList.createTile();
    });
  }

  void newGame({int size = 4}) {
    setState(() {
      gameOver = false;
      _isMoving = false;
      buttonsList = Field(size: size);
    });
  }

  void moveTiles(Direction direction) {
    setState(() {
      if(!buttonsList.notMoved) buttonsList.saveBoard();
      buttonsList.moveTiles(direction);
      buttonsList.createTile();
      
    });
  }
  void redo() {
    setState(() {
      buttonsList.setBoard();
      buttonsList.notMoved = true;
    });
  }

  void animateMovingTile(Direction direction){

  }

}


