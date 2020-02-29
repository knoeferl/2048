import 'package:flutter/material.dart';
import '../models/field.dart';
import '../widgets/Tile.dart';

class Game extends StatefulWidget {
  Game({Key key}) : super(key: key);

  @override
  _GameState createState() => _GameState();
}

class _GameState extends State<Game> {
  bool gameOver;
  bool _isMoving;
  Field buttonsList;
  double totalwidth = 100;
  GlobalKey _fieldkey = GlobalKey();
  void t() {}

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
                              onPressed: () => newGame(),
                              child: Icon(Icons.autorenew)),
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
                  child: Container(
                key: _fieldkey,
                    decoration: BoxDecoration(color: Colors.grey[500]),
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
                      child: Stack(
                          children: Iterable.generate(
                              buttonsList.flatList().length, (i) {
                        var tileWidth = totalwidth / buttonsList.getLength();
                        print(totalwidth.toString());
                        print(tileWidth.toString());
                        return Positioned(
                            left: (i % buttonsList.getLength() * tileWidth)
                                .toDouble(),
                            top: ((i / buttonsList.getLength())
                                        .toDouble()
                                        .floor() *
                                    tileWidth)
                                .toDouble(),
                            child: Tile(
                              context: context,
                              buttonsList: buttonsList,
                              i: i,
                              tileWidth: tileWidth,
                            ));
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
      buttonsList.moveTiles(direction);
      buttonsList.createTile();
    });
  }
}

class ListDrawer extends StatefulWidget {
  const ListDrawer({Key key, this.lastFocusNode, this.newGame})
      : super(key: key);
  final Function newGame;
  final FocusNode lastFocusNode;

  @override
  _ListDrawerState createState() => _ListDrawerState();
}

class _ListDrawerState extends State<ListDrawer> {
  static final numItems = 3;

  int selectedItem = 0;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Drawer(
      child: SafeArea(
        child: ListView(
          children: [
            ListTile(
              title: Text(
                "2048",
                style: textTheme.title,
              ),
              subtitle: Text(
                "created by Graf",
                style: textTheme.body1,
              ),
            ),
            Divider(),
            ...Iterable<int>.generate(numItems).toList().map((i) {
              int fieldsize = i + 3;
              final listTile = ListTile(
                enabled: true,
                selected: i == selectedItem,
                leading: Icon(Icons.autorenew),
                title: Text(
                  fieldsize.toString() + "x" + fieldsize.toString(),
                ),
                onTap: () {
                  setState(() {
                    selectedItem = i;
                    widget.newGame(size: fieldsize);
                  });
                },
              );

              if (i == numItems - 1 && widget.lastFocusNode != null) {
                return Focus(
                  focusNode: widget.lastFocusNode,
                  child: listTile,
                );
              } else {
                return listTile;
              }
            }),
          ],
        ),
      ),
    );
  }
}
