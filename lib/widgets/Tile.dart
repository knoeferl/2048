import 'package:flutter/material.dart';
import '../models/tileColors.dart';
import '../models/field.dart';

class Tile extends StatelessWidget {
  const Tile({
    Key key,
    @required this.buttonsList,
    @required this.context,
    @required this.tileNum,
    @required this.tileWidth,
  }) : super(key: key);

  final Field buttonsList;
  final context;
  final tileNum;
  final tileWidth;

  @override
  Widget build(BuildContext context) => SizedBox(
                  width: tileWidth,
                  height: tileWidth,
                  child: Padding(
                    padding: const EdgeInsets.all(5.0),
                    child: Container(
                      color: tileColors.containsKey(
                              buttonsList.flatList()[tileNum].value)
                          ? tileColors[buttonsList.flatList()[tileNum].value]
                          : Colors.blue[500],
                      
                      padding: const EdgeInsets.all(15.0),
                      child: FittedBox(
                        child: Text(
                          buttonsList.flatList()[tileNum].value == 0
                              ? " "
                              : buttonsList
                                  .flatList()[tileNum]
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