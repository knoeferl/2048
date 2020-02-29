import 'package:flutter/material.dart';
import '../models/tileColors.dart';
import '../models/field.dart';

class Tile extends StatelessWidget {
  const Tile({
    Key key,
    @required this.buttonsList,
    @required this.context,
    @required this.i,
    @required this.tileWidth,
  }) : super(key: key);

  final Field buttonsList;
  final context;
  final i;
  final tileWidth;

  @override
  Widget build(BuildContext context) => SizedBox(
                  width: tileWidth,
                  height: tileWidth,
                  child: Padding(
                    padding: const EdgeInsets.all(5.0),
                    child: Container(
                      color: tileColors.containsKey(
                              buttonsList.flatList()[i].value)
                          ? tileColors[buttonsList.flatList()[i].value]
                          : Colors.blue[500],
                      
                      padding: const EdgeInsets.all(15.0),
                      child: FittedBox(
                        child: Text(
                          buttonsList.flatList()[i].value == 0
                              ? " "
                              : buttonsList
                                  .flatList()[i]
                                  .value
                                  .toString(),
                          style: new TextStyle(
                              color: Colors.black, fontSize: 10.0),
                        ),
                      ),
                    ),
                  ),
                );
}