import 'package:flutter/material.dart';
import '../models/tileColors.dart';
import '../models/field.dart';
import '../models/tile.dart';

class TileBox extends StatefulWidget {
  const TileBox({
      Key? key,
    required this.tile,
    required this.buttonsList,
    required this.context,
    required this.tileNum,
    required this.tileWidth,
  }) : super(key: key);

  final Field buttonsList;
  final context;
  final int tileNum;
  final double tileWidth;
  final Tile tile;

  @override
  _TileBoxState createState() => _TileBoxState();
}

class _TileBoxState extends State<TileBox> with SingleTickerProviderStateMixin{
  late AnimationController controller;
  late Animation<double> animation;
  @override
  Widget build(BuildContext context) { 
      if (widget.tile.isNew && !widget.tile.isEmpty()) {
      controller.reset();
      controller.forward();
      widget.tile.isNew = false;
    } else {
      controller.animateTo(1.0);
    }
    double tileWidth = widget.tileWidth;
    return AnimatedTile(tileWidth: tileWidth, animation: animation, widget: widget,);
  }
         @override
  void initState() {
    super.initState();
    controller = AnimationController(
      duration: const Duration(
        milliseconds: 1000,
      ),
      vsync: this,
    );     
    animation = Tween(begin: 0.0, end: 1.0).animate(controller);
  } 
    @override
  void dispose() {
    controller.dispose();
    super.dispose();
    widget.tile.isNew = false;
  } 
 




}

class AnimatedTile extends AnimatedWidget {
  const AnimatedTile({
     Key? key,
    required this.tileWidth,
    required this.animation,
    required this.widget,
  }) : super(key: key, listenable: animation);

  final double tileWidth;
  final Animation<double> animation;
  final TileBox widget;


  @override
  Widget build(BuildContext context) {
    return SizedBox(
                  width: tileWidth,
                  height: tileWidth,
                  child: Padding(
                    padding: EdgeInsets.all(5*animation.value.toDouble()),
                    child: Container(
                      color: tileColors.containsKey(
                              widget.buttonsList.flatList()[widget.tileNum].value)
                          ? tileColors[widget.buttonsList.flatList()[widget.tileNum].value]
                          : Colors.blue[500],
                      
                      padding: const EdgeInsets.all(15.0),
                      child: FittedBox(
                        child: Text(
                          widget.buttonsList.flatList()[widget.tileNum].value == 0
                              ? " "
                              : widget.buttonsList
                                  .flatList()[widget.tileNum]
                                  .value
                                  .toString(),
                          style: const TextStyle(
                              color: Colors.black, fontSize: 10.0),
                        ),
                      ),
                    ),
                  ),
                );
  }
}