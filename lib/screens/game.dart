import 'package:flutter/material.dart';
import '../models/field.dart';
import '../widgets/TileBox.dart';
import '../widgets/listdrawer.dart';
import 'dart:math' as math;

class Game extends StatefulWidget {
  Game({Key? key}) : super(key: key);

  @override
  _GameState createState() => _GameState();
}

class _GameState extends State<Game> {
  late bool gameOver;
  late bool _isMoving;
  late Field buttonsList;
  double totalWidth = 400;
  int animationTime = 0;

  @override
  void initState() {
    super.initState();
    gameOver = false;
    _isMoving = false;
    buttonsList = Field();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: ListDrawer(newGame: newGame),
      appBar: AppBar(
          title: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: const <Widget>[Text("2048")],
      )),
      body: Container(
        decoration: BoxDecoration(
          color: Colors.orange[50],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Container(
              height: 100,
              margin: const EdgeInsets.all(8.0),
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                mainAxisSize: MainAxisSize.max,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  Expanded(
                    child: Container(
                      decoration: BoxDecoration(color: Colors.orange[100]),
                      child: FittedBox(
                        child: Column(
                          children: <Widget>[
                            const Text(
                              "score",
                              textScaleFactor: 7,
                            ),
                            Text(
                              "${buttonsList.score}",
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
                      child: TextButton(
                          style:
                              TextButton.styleFrom(primary: Colors.orange[100]),
                          onPressed: () => redo(),
                          child: Transform(
                            alignment: Alignment.center,
                            transform: Matrix4.rotationY(math.pi),
                            child: const Icon(Icons.redo),
                          )),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(

              child: FittedBox(
                fit: BoxFit.contain,
                child: GestureDetector(
                  onVerticalDragUpdate: moveVertical,
                  onVerticalDragEnd: stopMoving,
                  onVerticalDragCancel: stopMoving2,
                  onHorizontalDragUpdate: moveHorizontal,
                  onHorizontalDragEnd: stopMoving,
                  onHorizontalDragCancel: stopMoving2,
                  child: Container(
                    padding: const EdgeInsets.all(5),
                    width: totalWidth,
                    height: totalWidth,
                    decoration: BoxDecoration(color: Colors.grey[500]),
                    child: Stack(
                      children: Iterable.generate(
                        buttonsList.flatList().length,
                        (tileNum) {
                          var tileWidth = totalWidth / buttonsList.getLength();
                          return AnimatedPositioned(
                            onEnd: () =>
                                WidgetsBinding.instance.addPostFrameCallback((_) {
                              animationTime = 10;
                              setState(() {
                                for (var row in buttonsList.board) {
                                  for (var tile in row) {
                                    tile.value = tile.newValue;
                                    tile.positionHorizontal = 0;
                                    tile.positionVertical = 0;
                                  }
                                }
                              });
                            }),
                            key: Key("tile_$tileNum"),
                            left: left(tileNum, tileWidth),
                            top: top(tileNum, tileWidth),
                            duration: Duration(milliseconds: animationTime),
                            child: TileBox(
                              context: context,
                              buttonsList: buttonsList,
                              tileNum: tileNum,
                              tileWidth: tileWidth,
                              tile: buttonsList.flatList()[tileNum],
                            ),
                          );
                        },
                      ).toList(),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  double top(int tileNum, double tileWidth) {
    return ((tileNum / buttonsList.getLength()).floor() * tileWidth) +
        (buttonsList.flatList()[tileNum].positionVertical * tileWidth);
  }

  double left(int tileNum, double tileWidth) {
    return (tileNum % buttonsList.getLength() * tileWidth) +
        (buttonsList.flatList()[tileNum].positionHorizontal * tileWidth);
  }

  void stopMoving2() {
    _isMoving = false;
  }

  void stopMoving(d) {
    _isMoving = false;
  }

  void moveHorizontal(d) {
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
  }

  void moveVertical(detail) {
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
      animationTime = 200;
      if (!buttonsList.notMoved) buttonsList.saveBoard();
      buttonsList.moveTiles(direction);
      if (buttonsList.gameWon && !buttonsList.playAfterWon) wonDialog(context);
      if (!buttonsList.createTile() && buttonsList.gamelost()) {
        lostDialog(context);
      }
    });
  }

  void redo() {
    setState(() {
      buttonsList.setBoard();
      buttonsList.notMoved = true;
    });
  }

  wonDialog(BuildContext context) {
    return showDialog(
        context: context,
        builder: (_) => AlertDialog(
              title: const Text("you won!"),
              actions: <Widget>[
                IconButton(
                    onPressed: () => newGame(size: buttonsList.getLength()),
                    icon: const Icon(Icons.refresh)),
              ],
            ));
  }

  lostDialog(BuildContext context) {
    return showDialog(
        context: context,
        builder: (_) => AlertDialog(
              title: const Text("Lost"),
              actions: <Widget>[
                IconButton(
                    onPressed: () => newGame(size: buttonsList.getLength()),
                    icon: const Icon(Icons.refresh)),
              ],
            ));
  }
}
