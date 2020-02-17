import 'package:flutter/material.dart';
import '../models/tile.dart';
import '../models/field.dart';


class Game extends StatefulWidget {
  Game({Key key}) : super(key: key);

  @override
  _GameState createState() => _GameState();
}

class _GameState extends State<Game> {

  Field buttonsList;

  @override
  void initState() {
    super.initState();

    buttonsList = Field();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: new AppBar(
        title: new Text("2048"),
      ),
      body: new Column(
        mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children:<Widget>[
            Expanded(
              flex: 5,
              child: GridView.builder(
                padding: const EdgeInsets.all(10.0),
                gridDelegate: new SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: buttonsList.getLength(),
                    childAspectRatio: 1.0,
                    crossAxisSpacing: 0,
                    mainAxisSpacing: 0),
                itemCount: buttonsList.flatList().length,
                itemBuilder: (context, i) => SizedBox(
                  width: 100.0,
                  height: 100.0,
                  child: DecoratedBox(
                    position: DecorationPosition.foreground,
                    decoration: BoxDecoration(),
                    child: RaisedButton(
                      color: Color(3),
                      padding: const EdgeInsets.all(8.0),
                      onPressed: () {
                        return createTile();
                      },
                      child: FittedBox(
                        child: Text(
                          buttonsList.flatList()[i].value == 0
                              ? " "
                              : buttonsList.flatList()[i].value.toString(),
                          style: new TextStyle(
                              color: Colors.black,
                              fontSize: 20.0),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),

          ]
      ),
    );
  }

void createTile() {
    setState(() {
      buttonsList.createTile();
    });
  }

}